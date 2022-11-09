class QaasController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  authorize_resource

  def index
    @qes_bank = QesBank.find(iddecode(params[:qes_bank_id]))
    @qaas = @qes_bank.qaas
  end
   


   
  def show
    @qes_bank = QesBank.find(iddecode(params[:qes_bank_id]))
    @qaa = @qes_bank.qaas.find(iddecode(params[:id]))
  end
   

   
  def new
    @qes_bank = QesBank.find(iddecode(params[:qes_bank_id]))
    @qaa = Qaa.new
  end
   

   
  def create
    @qaa = Qaa.new(qaa_params)
     
    if @qaa.save
      redirect_to :action => :index
    else
      render :new
    end
  end
   
  def edit
    @qes_bank = QesBank.find(iddecode(params[:qes_bank_id]))
    @qaa = @qes_bank.qaas.find(iddecode(params[:id]))
  end
   
  def update
    @qes_bank = QesBank.find(iddecode(params[:qes_bank_id]))
    @qaa = @qes_bank.qaas.find(iddecode(params[:id]))
   
    if @qaa.update(qaa_params)
      redirect_to edit_qes_bank_qaa_path(idencode(@qes_bank.id), idencode(@qaa.id)) 
    else
      render :edit
    end
  end
   
  def destroy
    @qes_bank = QesBank.find(iddecode(params[:qes_bank_id]))
    @qaa = @qes_bank.qaas.find(iddecode(params[:id]))
   
    @qaa.destroy
    redirect_to :action => :index
  end
   
  def xls_download
    send_file File.join(Rails.root, "templates", "问答题模板.xlsx"), :filename => "问答题模板.xlsx", :type => "application/force-download", :x_sendfile=>true
  end
  
  
  
  def parse_excel
    qes_bank = QesBank.find(iddecode(params[:qes_bank_id]))
    parse = ParseQaa.new(current_user)
    excel = params["excel_file"]
    parse.process(qes_bank, excel)

    redirect_to :action => :index
  end 
  

  private
    def qaa_params
      params.require(:qaa).permit( :title, :answer)
    end
  
  
  
end

