require 'yaml'
require 'logger'

namespace 'db' do
  desc "init wenda"
  task(:import_wendas => :environment) do
    file = "lib/tasks/data/wendatiku.txt"
    contents = File.read(file)
    ctns = contents.split('#$#')
    ctns.each do |ctn|
      arr = ctn.strip.split('#!!!#')

      title = arr[0]
      answer = arr[1]
      
      Qaa.create!(:title => title.strip, :answer => answer)
    end
  end
end
