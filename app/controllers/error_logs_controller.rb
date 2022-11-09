class ErrorLogsController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  #authorize_resource

   
  def index
    @error_logs = current_user.error_logs.order('created_at desc')
  end

  def download
    @error_log = current_user.error_logs.find(iddecode(params[:id]))
    send_file @error_log.log_url, :filename => @error_log.name, :type => "application/force-download", :x_sendfile=>true
  end
   


  private
    def error_log_params
      params.require(:error_log).permit( :name, :log_url)
    end
  
  
  
end

