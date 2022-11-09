class PapersController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  #authorize_resource

   
  def index
    @paper = Paper.new
   
    @papers = Paper.all.page( params[:page]).per( Setting.systems.per_page )
   
  end
   

  def query_all 
    items = Paper.all
   
    obj = []
    items.each do |item|
      obj << {
        #:factory => idencode(factory.id),
        :id => idencode(item.id),
       
        :name => item.name,
       
        :start_time => item.start_time,
       
        :end_time => item.end_time,
       
        :single => item.single,
       
        :single_score => item.single_score,
       
        :mcq => item.mcq,
       
        :mcq_score => item.mcq_score,
       
        :tof => item.tof,
       
        :tof_score => item.tof_score,
       
        :qaa => item.qaa,
       
        :qaa_score => item.qaa_score,
       
        :desc => item.desc
      
      }
    end
    respond_to do |f|
      f.json{ render :json => obj.to_json}
    end
  end



   
  def show
   
    @paper = Paper.find(iddecode(params[:id]))
   
  end
   

   
  def new
    @paper = Paper.new
    
  end
   

   
  def create
    @paper = Paper.new(paper_params)
     
    if @paper.save
      redirect_to :action => :index
    else
      render :new
    end
  end
   

   
  def edit
   
    @paper = Paper.find(iddecode(params[:id]))
   
  end
   

   
  def update
   
    @paper = Paper.find(iddecode(params[:id]))
   
    if @paper.update(paper_params)
      redirect_to paper_path(idencode(@paper.id)) 
    else
      render :edit
    end
  end
   

   
  def destroy
   
    @paper = Paper.find(iddecode(params[:id]))
   
    @paper.destroy
    redirect_to :action => :index
  end
   
   def generate_paper
     @paper = Paper.find(iddecode(params[:id]))
     name = @paper.name
     _start = @paper.start_time.strftime("%Y-%m-%d %H:%M")
     _end = @paper.end_time.strftime("%Y-%m-%d %H:%M")

     single = @paper.single
     mcq = @paper.mcq
     tof = @paper.tof

     single_score = @paper.single_score.to_s
     mcq_score = @paper.mcq_score.to_s
     tof_score = @paper.tof_score.to_s

     @qes_bank = QesBank.find(iddecode(params[:qes_bank_id]))
     obj = []
     select_single(@qes_bank, single, obj)
     select_mcq(@qes_bank, mcq, obj)
     select_tof(@qes_bank, tof, obj)

     respond_to do |f|
       f.json{ render :json => obj.to_json}
     end
   end

   def select_single(qes_bank, num, obj)
     @singles = qes_bank.singles.all.shuffle.sample(num)
     @singles.each_with_index do |item, number|
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
         :answer => answer
       }
     end
   end

   def select_mcq(qes_bank, num, obj) 
     @mcqs = qes_bank.mcqs.all.shuffle.sample(num)
     tag_arr = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H']
   
     @mcqs.each_with_index do |item, number|
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
         :answer => answer
       }
     end
   end

   def select_tof(qes_bank, num, obj) 
     @tofs = qes_bank.tofs.all.shuffle.sample(num)
    
     @tofs.each_with_index do |item, number|
       number = (number + 1).to_s + '、'
       option_arrs = [
         {"id": 0, "value": "A", "content": 'A 正确', "true_answer": item.answer ? true : false},
         {"id": 1, "value": "B", "content": 'B 错误', "true_answer": item.answer ? false : true}
       ]
       obj << {
         :type => '2',
         :title => number + item.title,
         :options => option_arrs,
         :answer => item.answer ? 'A' : 'B'
       }
     end
   end

   def download_paper
     @paper = Paper.find(iddecode(params[:id]))

     docWorker = ExportPaperDoc.new    
     target_word = docWorker.process(@paper.id)
     send_file target_word, :filename => @paper.name + ".docx", :type => "application/force-download", :x_sendfile=>true
   end

  

  

  
  
  

  private
    def paper_params
      params.require(:paper).permit( :name, :start_time, :end_time, :single, :single_score, :mcq, :mcq_score, :tof, :tof_score, :qaa, :qaa_score, :desc)
    end
  
  
  
end

