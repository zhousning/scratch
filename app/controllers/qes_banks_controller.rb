class QesBanksController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  authorize_resource

   
  def index
    @qes_bank = QesBank.new
    @learn_ctgs = LearnCtg.all
    @qes_banks = [] 
    if current_user.has_role?(Setting.roles.role_grp)
      @qes_banks = QesBank.order('created_at DESC').all.page( params[:page]).per( Setting.systems.per_page )
    else
      @qes_banks = current_user.qes_banks.order('created_at DESC').all.page( params[:page]).per( Setting.systems.per_page )
    end
  end
   


   
  def show
   
    #@qes_bank = current_user.qes_banks.find(iddecode(params[:id]))
    @qes_bank = QesBank.find(iddecode(params[:id]))
   
  end
   

   
  def new
    @qes_bank = QesBank.new
    
  end
   

   
  def create
    @learn_ctg = LearnCtg.find(iddecode(params[:learn_ctg]))
    @qes_bank = QesBank.new(qes_bank_params)
    @qes_bank.learn_ctg = @learn_ctg
    @qes_bank.user = current_user
     
    if @qes_bank.save
      redirect_to :action => :index
    else
      render :new
    end
  end
   

   
  def edit
    @learn_ctgs = LearnCtg.all
   
    #@qes_bank = current_user.qes_banks.find(iddecode(params[:id]))
    @qes_bank = QesBank.find(iddecode(params[:id]))
  end
   

   
  def update
    @learn_ctg = LearnCtg.find(iddecode(params[:learn_ctg]))
    #@qes_bank = current_user.qes_banks.find(iddecode(params[:id]))
    @qes_bank = QesBank.find(iddecode(params[:id]))
    @qes_bank.learn_ctg = @learn_ctg
   
    if @qes_bank.update(qes_bank_params)
      redirect_to edit_qes_bank_path(idencode(@qes_bank.id)) 
    else
      render :edit
    end
  end
   

   
  def destroy
   
    #@qes_bank = current_user.qes_banks.find(iddecode(params[:id]))
    @qes_bank = QesBank.find(iddecode(params[:id]))
   
    @qes_bank.destroy
    redirect_to :action => :index
  end
   
  private
    def qes_bank_params
      params.require(:qes_bank).permit( :name, :editor, :single_count, :mcq_count, :tof_count, :qaa_count , :photo)
    end
  
  
  
end

