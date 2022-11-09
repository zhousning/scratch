require 'yaml'
require 'logger'
require 'find'
require 'json'

namespace 'db' do
  desc "import_sebcbanks"
  task(:import_sebcbanks => :environment) do
    log_dir = "lib/tasks/data/inoutcms/logs/" 
    sebcbanks_dir = "lib/tasks/data/sebc_banks/" 
    @error_log = Logger.new(log_dir + 'sebc_banks_error.log')
    @tags = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H']

    Find.find(sebcbanks_dir).each do |file|
      puts file
      unless File::directory?(file)
        sebcnames = file.gsub(sebcbanks_dir, '').gsub('.json', '')
        name_arr = sebcnames.split('/')
        
        @learn_ctg = LearnCtg.find_by_name(name_arr[0])
        @learn_ctg = LearnCtg.create!(:name => name_arr[0]) unless @learn_ctg
        @qes_bank = QesBank.where(:learn_ctg => @learn_ctg, :name => name_arr[2], :editor => name_arr[1]).first
        @qes_bank = QesBank.create(:learn_ctg => @learn_ctg, :name => name_arr[2], :editor => name_arr[1]) if @qes_bank.nil?

        json = File.read(file)
        sebcbanks = JSON.parse(json)
        sebcLists = sebcbanks['value']['subjectLevelList'] || sebcbanks['value']['subjectList']
        sebcLists.each do |item|
          type = item['type']
          title = item['title']
          answer = item['answer'].blank? ? '' : item['answer'].strip
          analyzeContent = item['analyzeContent']

          if type == 1 #单选题
            @single = Single.create!(:qes_bank => @qes_bank, :title => title)
            @tags.each do |tag|
              unless item['option' + tag].blank?
                option_title = item['option' + tag] 
                flag = false
                flag = true if answer == tag 
                SingleOption.create(:title => option_title, :single => @single, :answer => flag)
              end 
            end
          elsif type == 3 #判断题
            flag = answer == '0' ? false : true
            Tof.create!(:qes_bank => @qes_bank, :title => title, :answer => flag)
          elsif type == 4 #问答题
            Qaa.create!(:qes_bank => @qes_bank, :title => title, :answer => analyzeContent)
          end
        end
      end
    end
  end
end



#sebcList['topic_list'].each do |item|
#  answer  = item['answer_option']
#  title   = gsub_html(item['content'])
#  options = item['option_list']
#
#  if sebctype[0] == '多选题'
#    ansmtch = answer.scan(/[ABCDEFGH]/) 
#    @mcq = Mcq.create!(:sebc_bank_id => sebc_bank_id, :title => title)
#    options.each do |option|
#      option_title = gsub_html(option['content'])
#      option_seq = option['seq']
#      if ansmtch.include?(option_seq)
#        flag = true
#        McqOption.create(:title => option_title, :mcq => @mcq, :answer => flag, :sequence => ansmtch.index(option_seq) + 1)
#      else
#        McqOption.create(:title => option_title, :mcq => @mcq)
#      end
#    end
#  else
#    puts '题型未识别出来'
#  end
#end
