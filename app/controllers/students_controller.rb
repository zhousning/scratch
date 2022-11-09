class StudentsController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  authorize_resource

   
  def index
    @factory = my_factory
    @students = [] 
    exclude_users = [Setting.admins.phone, "15763703188", "1239988"]
    users = @factory.users.where(['phone not in (?)', exclude_users])
    users.each do |user|
      @students << {:name => user.name, :idno => user.phone, :fct => @factory.name, :id => idencode(user.id), :fct_id => idencode(@factory.id)} 
    end
  end

  def all 
    @students = []
    if current_user.has_role?(Setting.roles.role_grp)
      users = WxUser.all
      users.each do |user|
        name = user.name || ''
        nickname = user.nickname || ''
        phone = user.phone || ''
        fct = user.factory.nil? ? '' : user.factory.name
        @students << {:name => name, :nickname => nickname, :idno => phone, :fct => fct} 
      end
    else
      @factory = current_user.factories.first 
      users = @factory.wx_users 
      users.each do |user|
        name = user.name || ''
        phone = user.phone || ''
        @students << {:name => name, :nickname => nickname, :idno => phone, :fct => @factory.name} 
      end
    end
  end

  #暂时不用
  def all_user
    @students = [] 
    exclude_users = [Setting.admins.phone, "15763703188", "1239988"]
    users = User.where(['phone not in (?)', exclude_users]).all
    users.each do |user|
      @students << {:name => user.name, :idno => user.phone, :fct => user.factories.first.name} 
    end
  end
   

  def query_all 
    items = User.all
   
    obj = []
    items.each do |item|
      obj << {
        #:factory => idencode(factory.id),
        :id => idencode(item.id),
       
        :name => item.name,
       
        :identity => item.identity
      
      }
    end
    respond_to do |f|
      f.json{ render :json => obj.to_json}
    end
  end

  def edit
    @factory = my_factory
    @student = @factory.users.where(:id => iddecode(params[:id])).first
  end
   
  def update
    @factory = my_factory
    @student = @factory.users.where(:id => iddecode(params[:id])).first
   
    if @student.update(student_params)
      redirect_to edit_factory_student_path(idencode(@factory.id), idencode(@student.id)) 
    else
      render :edit
    end
  end
   
  def destroy
    @factory = my_factory
    @student = @factory.users.where(:id => iddecode(params[:id])).first
   
    @student.destroy
    redirect_to :action => :index
  end
  
  def xls_download
    send_file File.join(Rails.root, "templates", "users.xlsx"), :filename => "学生信息模板.xlsx", :type => "application/force-download", :x_sendfile=>true
  end
  
  
  
  def parse_excel
    @factory = my_factory
    @role_student = Role.where(:name => Setting.roles.role_student).first
    @role_fct = Role.where(:name => Setting.roles.role_fct).first
    @student_role = [@role_fct, @role_student]

    excel = params["excel_file"]
    tool = ExcelTool.new
    results = tool.parseExcel(excel.path)

    name = ""
    identity = ""

    results["Sheet1"][1..-1].each do |items|
      items.each do |k, v|
        if !(/A/ =~ k).nil?
          name = v.nil? ? "" : v 
        elsif !(/B/ =~ k).nil?
          identity = v.nil? ? "" : v 
        end

        next if name.blank? || identity.blank?

        user_name = name.gsub(/\s/, "") 
        user_identity = identity.gsub(/\s/, "") 
        password = user_identity[6..13]

        user = User.where(:phone => user_identity).first
        next unless user.nil?

        User.create(:name => user_name, :phone => user_identity, :identity => user_identity, :password => password, :password_confirmation => password, :roles => @student_role, :factories => [@factory])
      end
    end

    redirect_to :action => :index
  end 
  

  private
    def student_params
      params.require(:student).permit( :name, :identity , :photo)
    end
  
  
  
end

