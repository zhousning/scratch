require 'yaml'
require 'logger'

namespace 'db' do
  desc "init duoxuan"
  task(:import_duoxuans => :environment) do
    file = "lib/tasks/data/duoxuantiku.txt"
    contents = File.read(file)
    ctns = contents.split('#$#')
    ctns.each do |ctn|
      arr = ctn.strip.split(/\r\n/)
      if arr.size != 3
        puts ctn
      end

      titles = arr[0].strip
      options = arr[1].strip
      answer = arr[2].strip.upcase

      ansmtch = answer.scan(/[ABCDEFGH]/) 

      title_mch = /(\d+\p{P})(.+)/.match(titles)
      orderno = title_mch[1]
      title = title_mch[2]

      if ansmtch.nil? || title.nil?
        puts orderno + "title has error"
        break
      end
      
      @mcq = Mcq.create!(:title => title.strip)
      opt_arr = options.scan(/[ABCDEFGH][^ABCDEFGH]+/)
      flag = false
      opt_arr.each do |opt|
        opts = /([ABCDEFGH])(\p{P}*)([^ABCDEFGH]+)/.match(opt.upcase)
        ans = opts[1]
        if opts[3].nil?
          puts orderno + "answer has error"
          break
        end
        if ansmtch.include?(ans)
          flag = true
          McqOption.create(:title => opts[3].strip, :mcq => @mcq, :answer => flag, :sequence => ansmtch.index(ans) + 1)
        else
          McqOption.create(:title => opts[3].strip, :mcq => @mcq)
        end
      end

      if !flag
        puts orderno + "answer has error"
        break
      end
    end
  end
end
