# encoding: UTF-8

require 'restclient'
require 'open-uri'
require 'open_uri_redirections'
require 'nokogiri'
require 'json'
require 'yaml'
require 'logger'
require 'find'
require 'fileutils'
require 'base64'
require 'tempfile'


namespace 'db' do
  desc "import_sebcbanks"
  task(:import_sebcbanks => :environment) do
    log_dir = "lib/tasks/data/inoutcms/logs/" 
    sebcbanks_dir = "lib/tasks/data/sebc_banks/" 
    @error_log = Logger.new(log_dir + 'sebc_banks_error.log')
    @tags = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H']


    Find.find(sebcbanks_dir).each do |file|
      unless File::directory?(file)
        begin
          puts file
          sebcnames = file.gsub(sebcbanks_dir, '').gsub('.json', '')
          name_arr = sebcnames.split('/')
          
          @learn_ctg = LearnCtg.find_by_name(name_arr[0])
          @learn_ctg = LearnCtg.create!(:name => name_arr[0]) unless @learn_ctg
          @qes_bank = QesBank.where(:learn_ctg => @learn_ctg, :name => name_arr[2], :editor => name_arr[1]).first
          @qes_bank = QesBank.create(:learn_ctg => @learn_ctg, :name => name_arr[2], :editor => name_arr[1]) if @qes_bank.nil?

          sebcimages_folder = Rails.root.join("public", "sebcimages", @qes_bank.name).to_s
          FileUtils.makedirs(sebcimages_folder) unless File.directory?(sebcimages_folder)

          json = File.read(file)
          sebcbanks = JSON.parse(json)
          sebcLists = sebcbanks['value']['subjectLevelList'] || sebcbanks['value']['subjectList']
          sebcLists.each do |item|
            type = item['type']
            title = convert_base64(item['title'])
            answer = item['answer'].blank? ? '' : convert_base64(item['answer'].strip)
            analyzeContent = convert_base64(item['analyzeContent'])

      
            if type == 1 #单选题
              @single = Single.create!(:qes_bank => @qes_bank, :title => title, :analyze_content => analyzeContent)
              @tags.each do |tag|
                unless item['option' + tag].blank?
                  option_title = convert_base64(item['option' + tag]) 
                  flag = false
                  flag = true if answer == tag 
                  SingleOption.create(:title => option_title, :single => @single, :answer => flag)
                end 
              end
            elsif type == 2 #多选题
              ansmtch = answer.scan(/[ABCDEFGH]/) 
              @mcq = Mcq.create!(:qes_bank => @qes_bank, :title => title, :analyze_content => analyzeContent)
              @tags.each do |tag|
                unless item['option' + tag].blank?
                  option_title = convert_base64(item['option' + tag]) 
                  if ansmtch.include?(tag)
                    McqOption.create(:title => option_title, :mcq => @mcq, :answer => true, :sequence => ansmtch.index(tag) + 1)
                  else
                    McqOption.create(:title => option_title, :mcq => @mcq)
                  end
                end
              end
            elsif type == 3 #判断题
              flag = answer == '0' ? false : true
              Tof.create!(:qes_bank => @qes_bank, :title => title, :answer => flag, :analyze_content => analyzeContent)
            elsif type == 4 #问答题
              Qaa.create!(:qes_bank => @qes_bank, :title => title, :answer => answer, :analyze_content => analyzeContent)
            else
              puts type
            end
          end
        rescue Exception => e
          puts e.message
          break
        end
      end
    end
  end
end

def convert_base64(content)
  content.gsub!(/<img/i,'<img style="max-width:100%;height:auto"')
  content.gsub!(/src="http[^"]*"/) do |src|
    image_src = src.gsub('src=', '').gsub(/"/, '')
    img = download_file(image_src)
    "src='" + img + "'"
  end
  content.gsub!(/src="data:[^"]*"/) do |src|
    image_src = src.gsub('src=', '').gsub(/"/, '')
    img = base64_to_image(image_src)
    "src='" + img + "'"
  end
  content
end

def download_file(image_src)
  name = Time.now.to_i.to_s + "%04d" % [rand(10000)]
  sebcimage = Rails.root.join("public", "sebcimages", @qes_bank.name, name).to_s
  begin
    File.open(sebcimage, "w") do |f|
      f.write(open(image_src, :allow_redirections => :all).read.force_encoding('utf-8'))
    end
  rescue Exception => e   
    @error_log.error "download file error: #{image_src}" + e.message
  end
  return "/sebcimages/" + @qes_bank.name + "/" + name
end

def base64_to_image(image)
  name = Time.now.to_i.to_s + "%04d" % [rand(10000)]
  sebcimage = Rails.root.join("public", "sebcimages", @qes_bank.name, name).to_s

  image = image.gsub!(/data:.*base64,/, '') 
  result = Base64.decode64(image)
  begin
    File.open(sebcimage, "wb") do |f|
      f.write(result)
    end
  rescue Exception => e   
    puts e.message
  end
  return "/sebcimages/" + @qes_bank.name + "/" + name
end

#def convert_base64(content)
#  content.gsub!(/<img/i,'<img style="max-width:100%;height:auto"')
#  content.gsub!(/src="http[^"]*"/) do |src|
#    image_src = src.gsub('src=', '').gsub(/"/, '')
#    file = open(image_src, :allow_redirections => :all).read
#    img = Base64.encode64(file)
#    "src='data:image;base64," + img + "'"
#  end
#  content
#end
