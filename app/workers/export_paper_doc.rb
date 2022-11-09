#不用异步
class ExportPaperDoc

  def process(paper_id)
    @paper = Paper.find(paper_id)

    export_process(@paper)
  end

  def export_process(paper)
    target_folder = Rails.root.join("public", "papers").to_s
    target_docx = target_folder + '/' + paper.name + '.docx'

    docx = Caracal::Document.new(target_docx)
    style_config(docx)

    name = paper.name
    _start = paper.start_time.strftime("%Y-%m-%d %H:%M")
    _end = paper.end_time.strftime("%Y-%m-%d %H:%M")
    single = paper.single
    single_score = paper.single_score.to_s
    mcq = paper.mcq
    mcq_score = paper.mcq_score.to_s
    tof = paper.tof
    tof_score = paper.tof_score.to_s
    qaa = paper.qaa
    qaa_score = paper.qaa_score.to_s

    order = 0

    answers = ""
    tag = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'] 

    docx.h2 name
    docx.p '考试时间：' + _start + '--' + _end
    
    if single != 0
      order += 1
      @singles = Single.all.sample(single)
      header = order.to_s + '单项选择题(每题' + single_score + '分)' 
      docx.h4 header 
      answers += header + '#$#'

      @singles.each_with_index do |sg, index|
        key = index+1
        key = key.to_s
        docx.p key + ' ' + sg.title
        options = sg.single_options.shuffle
        options.each_with_index do |opt, ind|
          docx.p tag[ind] + " " + opt.title
          answers += key + tag[ind] + ',  ' if opt.answer
        end
      end
    end

    if mcq != 0
      order += 1
      @mcqs = Mcq.all.sample(mcq)
      header = order.to_s + '多项选择题(每题' + mcq_score + '分)'
      docx.h4 header 
      answers += '#$#' + header + '#$#'

      @mcqs.each_with_index do |mcq, index|
        key = index+1
        key = key.to_s
        docx.p key + ' ' + mcq.title
        options = mcq.mcq_options
        answer_cache = ''
        options.each_with_index do |opt, ind|
          docx.p tag[ind] + " " + opt.title
          answer_cache += tag[ind] if opt.answer
        end
        answers += key + answer_cache + ',  '
      end
    end

    if tof != 0
      order += 1
      @tofs = Tof.all.sample(tof)
      header = order.to_s + '判断题(每题' + tof_score + '分)'
      docx.h4 header 
      answers += '#$#' + header + '#$#'

      @tofs.each_with_index do |tof, index|
        key = index+1
        key = key.to_s
        docx.p key + ' ' + tof.title

        if tof.answer
          answers += key + Setting.papers.right + ',  ' 
        else
          answers += key + Setting.papers.error + ',  '
        end
      end
    end

    if qaa != 0
      order += 1
      @qaas = Qaa.all.sample(qaa)
      header = order.to_s + '问答题(每题' + qaa_score + '分)'
      docx.h4 header 
      answers += '#$#' + header + '#$#'

      @qaas.each_with_index do |qaa, index|
        key = index+1
        key = key.to_s
        docx.p key + ' ' + qaa.title

        answers += '[第' + key + '题] ' + qaa.answer + '#$#'
      end
    end

    docx.page
    docx.h4 '试题答案'
    answers.split('#$#').each do |ans|
      docx.p ans
    end

    docx.save

    target_docx
  end

  def style_config(docx)
    docx.style do
      id "h2"
      name "h2"
      font "黑体"
      size 40
      bold true
      italic false
    end
    docx.style do
      id "h3"
      name "h3"
      font "黑体"
      size 36
      bold true
      italic false
    end
    docx.style do
      id "h4"
      name "h4"
      font "黑体"
      size 32
      bold true
      italic false
    end
    docx.style do
      id "p"
      name "p"
      font "宋体"
      size 30
      bold false 
      italic false
      indent_left 360
    end
    docx.style do
      id "table_caption"
      name "table_caption"
      align :center
      font "宋体"
      size 30
      bold false 
      italic false
    end
  end
end
