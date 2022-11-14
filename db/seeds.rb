# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

role = Role.create(:name => Setting.roles.super_admin)

admin_permissions = Permission.create(:name => Setting.permissions.super_admin, :subject_class => Setting.admins.class_name, :action => "manage")

role.permissions << admin_permissions

user = User.new(:phone => Setting.admins.phone, :password => Setting.admins.password, :password_confirmation => Setting.admins.password)
user.save!

user.roles = []
user.roles << role

AdminUser.create!(:phone => Setting.admins.phone, :email => Setting.admins.email, :password => Setting.admins.password, :password_confirmation => Setting.admins.password)

#@user = User.create!(:phone => "15763703188", :password => "15763703188", :password_confirmation => "15763703188")

###区分厂区和集团用户是为了sidebar显示
@role_fct = Role.where(:name => Setting.roles.role_fct).first
@role_grp = Role.where(:name => Setting.roles.role_grp).first

@role_qesbank = Role.where(:name => Setting.roles.role_qesbank).first
@role_law = Role.where(:name => Setting.roles.role_law).first
@role_learn = Role.where(:name => Setting.roles.role_learn).first
@role_notice = Role.where(:name => Setting.roles.role_notice).first
@role_advise = Role.where(:name => Setting.roles.role_advise).first
@role_ctg = Role.where(:name => Setting.roles.role_ctg).first
@role_student = Role.where(:name => Setting.roles.role_student).first

##厂区管理者
@fctmgn = [@role_fct, @role_student, @role_qesbank, @role_law, @role_learn,  @role_student]
##集团管理者
@grp_mgn = [@role_grp, @role_student, @role_qesbank, @role_law, @role_learn, @role_notice, @role_advise, @role_ctg] 


all_factories = Factory.all
user.factories << all_factories

#集团管理
grp_mgn = User.create!(:phone => "1239988", :password => "sdgykg9988", :password_confirmation => "sdgykg9988", :name => "山东公用控股管理者", :roles => @grp_mgn, :factories => all_factories)

#LearnCtg.create!(:name => 'Scratch')
#LearnCtg.create!(:name => 'Python')
#LearnCtg.create!(:name => 'C语言')
#LearnCtg.create!(:name => '机器人')

#LawCtg.create!(:name => '法律')
#LawCtg.create!(:name => '标准')
#LawCtg.create!(:name => '制度')
#LawCtg.create!(:name => '规范')

