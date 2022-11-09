class ParseTof
  def initialize(current_user)
    log_dir = File.join(Rails.root, "public", "errorlogs")
    Dir::mkdir(log_dir) unless File.directory?(log_dir)

    name = Time.now.strftime('%Y-%m-%d%H:%M:%S') + '上传判断题记录' + ".log"
    path = log_dir + '/' + name
    ErrorLog.create(:user => current_user, :name => name, :log_url => path) 
    @error = Logger.new(path)
  end

  def process(qes_bank, file)
    xls = file.path
    creek = Creek::Book.new(xls) 

    creek.sheets.each_with_index do |sheet, index| 
      sheet.with_images.rows.each do |row|
        content = row.reject { |key,value| value.to_s.blank? }
        if !content.blank?
          values = content.values
          c_first = values.first.strip
          c_last = values.last.strip

          title_mch = /(\d+\p{P})?(.+)/.match(c_first)
          q_title = title_mch[2]

          answer = nil 
          if c_last == '对'
            answer = true
          else
            answer = false
          end
          Tof.create!(:qes_bank => qes_bank, :title => q_title, :answer => answer)
        end
      end
    end
  end

  def process_txt(qes_bank, file)
    contents = File.read(file.path)
    ctns = contents.split(/\r\n/)
    ctns.each do |ctn|
      answer = /(?:true|false)/.match(ctn)

      if answer.nil?
        @error.error ctn + '题没有答案'
        next
      end

      title_ctn = ctn.gsub(/(?:true|false)/, '  ')

      title_mch = /(\d+\p{P})(.+)/.match(title_ctn)
      if title_mch.nil?
        @error.error ctn + '标题格式不正确'
        next
      end

      orderno = title_mch[1]
      title = title_mch[2]

      if title.nil?
        @error.error ctn + '标题有错误'
        next
      end

      @tof = qes_bank.tofs.where(:title => title.strip)
      next unless @tof.blank?

      Tof.create!(:qes_bank => qes_bank, :title => title.strip, :answer => answer[0])
    end
  end

end
