class WxQesbanksController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_filter :wxuser_exist?

  def query_all 
    #items = QesBank.all
    
    items = QesBank.select('editor').uniq
   
    obj = []
    items.each do |item|
      obj << {
        :id => idencode(item.id),
        :name => item.editor,
       
        #:name => item.name,
       
        #:single_count => item.single_count,
       
        #:mcq_count => item.mcq_count,
       
        #:tof_count => item.tof_count,
       
        #:qaa_count => item.qaa_count
      
      }
    end
    respond_to do |f|
      f.json{ render :json => obj.to_json}
    end
  end

  def query_type_all 
    qes_bank = QesBank.find(iddecode(params[:qes_bank_id]))
    single_count = qes_bank.singles.count
    mcq_count = qes_bank.mcqs.count
    tof_count = qes_bank.tofs.count
    qaa_count = qes_bank.qaas.count
    respond_to do |f|
      f.json{ render :json => {
        :single => single_count, 
        :mcq => mcq_count, 
        :tof => tof_count, 
        :qaa => qaa_count 
      }.to_json}
    end
  end

  def query_lib_all 
    learn_ctg = LearnCtg.find(iddecode(params[:learn_ctg_id]))
    items = learn_ctg.qes_banks.where(:editor => params[:qes_lib_name])
   
    obj = []
    items.each do |item|
      obj << {
        :id => idencode(item.id),
        :name => item.name,
      }
    end
    respond_to do |f|
      f.json{ render :json => {:title => params[:qes_lib_name], :res => obj}.to_json}
    end
  end

  def single_query_all 
    @qes_bank = QesBank.find(iddecode(params[:qes_bank_id]))
    items = @qes_bank.singles.all.shuffle
    tag_arr = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H']
   
    obj = []
    items.each_with_index do |item, number|
      number = (number + 1).to_s + '、'
      options = item.single_options.shuffle
      option_arrs = []
      answer = ''
      options.each_with_index do |opt, index|
        option_arrs << {
          "id": index,
          "value": tag_arr[index],
          "content": tag_arr[index] + ' ' + opt.title,
          "true_answer": opt.answer
        }
        answer = tag_arr[index] if opt.answer
      end
      obj << {
        :type => '0',
        :title => number + item.title,
        :options => option_arrs,
        :analyse => item.analyze_content,
        :answer => answer
      }
    end
    respond_to do |f|
      f.json{ render :json => obj.to_json}
    end
  end

  def mcq_query_all 
    @qes_bank = QesBank.find(iddecode(params[:qes_bank_id]))
    items = @qes_bank.mcqs.all.shuffle
    tag_arr = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H']
   
    obj = []
    items.each_with_index do |item, number|
      number = (number + 1).to_s + '、'
      options = item.mcq_options
      option_arrs = []
      answer = ''
      options.each_with_index do |opt, index|
        option_arrs << {
          "id": index,
          "value": tag_arr[index],
          "content": tag_arr[index] + ' ' + opt.title,
          "true_answer": opt.answer
        }
        answer += tag_arr[index] if opt.answer
      end
      obj << {
        :type => '1',
        :title => number + item.title,
        :options => option_arrs,
        :analyse => item.analyze_content,
        :answer => answer
      }
    end
    respond_to do |f|
      f.json{ render :json => obj.to_json}
    end
  end

  def tof_query_all 
    @qes_bank = QesBank.find(iddecode(params[:qes_bank_id]))
    items = @qes_bank.tofs.all.shuffle
   
    obj = []
    items.each_with_index do |item, number|
      number = (number + 1).to_s + '、'
      option_arrs = [
        {"id": 0, "value": "A", "content": 'A 正确', "true_answer": item.answer ? true : false},
        {"id": 1, "value": "B", "content": 'B 错误', "true_answer": item.answer ? false : true}
      ]
      obj << {
        :type => '2',
        :title => number + item.title,
        :analyse => item.analyze_content,
        :options => option_arrs,
        :answer => item.answer ? 'A' : 'B'
      }
    end
    respond_to do |f|
      f.json{ render :json => obj.to_json}
    end
  end


  def qaa_query_all 
    @qes_bank = QesBank.find(iddecode(params[:qes_bank_id]))
    items = @qes_bank.qaas.all.shuffle
   
    obj = []
    items.each_with_index do |item, number|
      number = (number + 1).to_s + '、'
      obj << {
        :type => '3',
        :title => number + item.title,
        :options => [],
        :analyse => item.analyze_content,
        :answer => item.answer
      }
    end
    respond_to do |f|
      f.json{ render :json => obj.to_json}
    end
  end



   

end
