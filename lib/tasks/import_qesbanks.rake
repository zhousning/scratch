require 'yaml'
require 'logger'
require 'find'
require 'json'

namespace 'db' do
  desc "import_qesbanks"
  task(:import_qesbanks => :environment) do
    exec_import_qesbanks
  end
end

def exec_import_qesbanks
  log_dir = "lib/tasks/data/inoutcms/logs/" 
  qesbanks_dir = "lib/tasks/data/qes_banks/" 
  @error_log = Logger.new(log_dir + 'qes_banks_error.log')
  qesbank_hash = Hash.new

  Find.find(qesbanks_dir).each do |file|
    unless File::directory?(file)
      qesname = File.basename(file).gsub('name=', '').gsub(/《.*》/, '').gsub('.json', '')
      qestype = /(?:单选题|多选题)/.match(file)

      qes_bank_id = nil 
      if qesbank_hash[qesname].nil?
        qes_bank = QesBank.create(:name => qesname, :editor => '中级注安')
        qes_bank_id = qes_bank.id
        qesbank_hash[qesname] = qes_bank_id
      else
        qes_bank_id = qesbank_hash[qesname]
      end
      
      json = File.read(file)
      qesbanks = JSON.parse(json)
      qesLists = qesbanks['data']['questionList']
      qesLists.each do |qesList|
        qesList['topic_list'].each do |item|
          answer  = item['answer_option']
          title   = gsub_html(item['content'])
          options = item['option_list']

          if qestype[0] == '单选题'
            @single = Single.create!(:qes_bank_id => qes_bank_id, :title => title)
            options.each do |option|
              option_title = gsub_html(option['content'])
              option_seq = option['seq']
              flag = answer.include?(option_seq)
              SingleOption.create(:title => option_title, :single => @single, :answer => flag)
            end
          elsif qestype[0] == '多选题'
            ansmtch = answer.scan(/[ABCDEFGH]/) 
            @mcq = Mcq.create!(:qes_bank_id => qes_bank_id, :title => title)
            options.each do |option|
              option_title = gsub_html(option['content'])
              option_seq = option['seq']
              if ansmtch.include?(option_seq)
                flag = true
                McqOption.create(:title => option_title, :mcq => @mcq, :answer => flag, :sequence => ansmtch.index(option_seq) + 1)
              else
                McqOption.create(:title => option_title, :mcq => @mcq)
              end
            end
          else
            puts '题型未识别出来'
          end
        end
      end

    end
  end

end

def gsub_html(str)
  str = str.gsub(/&amp;quot;/, '"');
  str = str.gsub(/&amp;amp;/, '&');
  str = str.gsub(/&amp;lt;/, '<');
  str = str.gsub(/&amp;gt;/, '>');

  str = str.gsub(/&quot;/, '"');
  str = str.gsub(/&amp;/, '&');
  str = str.gsub(/&lt;/, '<');
  str = str.gsub(/&gt;/, '>');
  str = str.gsub(/&nbsp;/, ' ');

  str = str.gsub(/<p>/, '');
  str = str.gsub(/<\/p>/, '');

  str
end
