require 'yaml'
require 'logger'

namespace 'db' do
  desc "init danxuan"
  task(:import_danxuans => :environment) do
    #file = "lib/tasks/data/danxuantiku.txt"
    file = "lib/tasks/data/ti2danxuan.txt"
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

      ansmtch = /[ABCDEF]/.match(answer) 

      title_mch = /(\d+\p{P})(.+)/.match(titles)
      orderno = title_mch[1]
      title = title_mch[2]

      puts title
      if ansmtch.nil? || title.nil?
        puts orderno + "title has error"
        break
      end
      
      @single = Single.create!(:title => title.strip)
      opt_arr = options.scan(/[ABCDEF][^ABCDEF]+/)
      flag = false
      count = 0
      opt_arr.each do |opt|
        puts opt
        opts = /([ABCDEF])(\p{P}*)([^ABCDEF]+)/.match(opt.upcase)
        ans = opts[1]
        if opts[3].nil?
          puts orderno + "answer has error"
          break
        end
        if ans == ansmtch[0]
          count += 1
          flag = true
          SingleOption.create(:title => opts[3].strip, :single => @single, :answer => flag)
        else
          SingleOption.create(:title => opts[3].strip, :single => @single)
        end
      end

      if !flag || count > 1
        puts orderno + "answer has error"
        break
      end
    end
  end
end
