require 'yaml'
require 'logger'

namespace 'db' do
  desc "init panduan"
  task(:import_panduans => :environment) do
    file = "lib/tasks/data/panduantiku.txt"
    contents = File.read(file)
    ctns = contents.split(/\r\n/)
    ctns.each do |ctn|

      answer = /(?:true|false)/.match(ctn)[0]
      title_ctn = ctn.gsub(/(?:true|false)/, '  ')

      title_mch = /(\d+\p{P})(.+)/.match(title_ctn)
      orderno = title_mch[1]
      title = title_mch[2]

      Tof.create!(:title => title.strip, :answer => answer)
    end
  end
end
