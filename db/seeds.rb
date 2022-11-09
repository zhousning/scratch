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

@user = User.create!(:phone => "15763703188", :password => "15763703188", :password_confirmation => "15763703188")

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

@gysw = Company.create!(:area => "梁山县", :name => "山东公用水务集团")
@jiax = Company.create!(:area => "嘉祥县", :name => "山东公用热电集团")
@wens = Company.create!(:area => "汶上县", :name => "山东公用商业集团")
@qufu = Company.create!(:area => "曲阜市", :name => "山东公用环卫集团")
@yanz = Company.create!(:area => "兖州区", :name => "山东公用环保科技集团")
@zouc = Company.create!(:area => "邹城市", :name => "济宁中山公用水务")
@renc = Company.create!(:area => "任城区", :name => "山东公用建工集团")
@beih = Company.create!(:area => "太白湖新区", :name => "济宁金水科技")
@jinx = Company.create!(:area => "金乡县", :name => "山东公用置业集团")

@gysw  = Factory.create!(:area => "梁山县",     :name => "山东公用水务集团",       :company => @gysw, :lnt => 116.648154, :lat => 35.471726, :design => 20000)
@zssw  = Factory.create!(:area => "邹城市",     :name => "济宁中山公用水务",       :company => @zouc, :lnt => 116.944881, :lat => 35.384207, :design => 80000)
@gyrd  = Factory.create!(:area => "嘉祥县",     :name => "山东公用热电集团",       :company => @jiax, :lnt => 116.344578, :lat => 35.397421, :design => 80000)
@gysy  = Factory.create!(:area => "汶上县",     :name => "山东公用商业集团",       :company => @wens, :lnt => 116.480951, :lat => 35.712144, :design => 40000)
@gyhw  = Factory.create!(:area => "曲阜市",     :name => "山东公用环卫集团",       :company => @qufu, :lnt => 116.970989, :lat => 35.583201, :design => 40000)
@yzsw  = Factory.create!(:area => "兖州区",     :name => "山东公用环保科技集团",       :company => @yanz, :lnt => 116.781921, :lat => 35.510729, :design => 60000)
@gyjg  = Factory.create!(:area => "任城区",     :name => "山东公用建工集团",     :company => @renc, :lnt => 116.648154, :lat => 35.471726, :design => 20000)
@jskj  = Factory.create!(:area => "太白湖新区", :name => "济宁金水科技",     :company => @beih, :lnt => 116.563934, :lat => 35.302149, :design => 20000)
@gyzy  = Factory.create!(:area => "金乡县",     :name => "山东公用置业集团", :company => @jinx, :lnt => 116.33235,  :lat => 35.095662, :design => 20000)

User.create!(:phone => "053737080101", :password => "gysw0101", :password_confirmation => "gysw0101", :name => "山东公用水务集团管理者",     :roles => @fctmgn,    :factories => [@gysw])
User.create!(:phone => "053766880909", :password => "zssw0909", :password_confirmation => "zssw0909", :name => "济宁中山公用水务管理者",     :roles => @fctmgn,    :factories => [@zssw])
User.create!(:phone => "053711114567", :password => "gyrd4567", :password_confirmation => "gyrd4567", :name => "山东公用热电集团管理者",     :roles => @fctmgn,    :factories => [@gyrd])
User.create!(:phone => "053766885858", :password => "gysy5858", :password_confirmation => "gysy5858", :name => "山东公用商业集团管理者",     :roles => @fctmgn,    :factories => [@gysy])
User.create!(:phone => "053798983708", :password => "gyhw3708", :password_confirmation => "gyhw3708", :name => "山东公用环卫集团管理者",     :roles => @fctmgn,    :factories => [@gyhw]) 
User.create!(:phone => "053766889999", :password => "gyjg9999", :password_confirmation => "gyjg9999", :name => "山东公用建工集团管理者",     :roles => @fctmgn,    :factories => [@gyjg]) 
User.create!(:phone => "053756786789", :password => "jskj6789", :password_confirmation => "jskj6789", :name => "济宁金水科技管理者",     :roles => @fctmgn,    :factories => [@jskj]) 
User.create!(:phone => "053766881234", :password => "gyzy6688", :password_confirmation => "gyzy6688", :name => "山东公用置业集团管理者",     :roles => @fctmgn,    :factories => [@gyzy])



all_factories = Factory.all
user.factories << all_factories

#集团运营
#grp_opt = User.create!(:phone => "15763703588", :password => "swjt3588", :password_confirmation => "swjt3588", :name => "水务集团运营", :roles => @grp_opt, :factories => all_factories)

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


#User.create!(:phone => "053769699898", :password => "gysw9898", :password_confirmation => "gysw9898", :name => "山东公用水务集团仓库管理员", :roles => @fct_whmgn, :factories => [@gysw])
#User.create!(:phone => "053769693708", :password => "gysw3708", :password_confirmation => "gysw3708", :name => "山东公用水务集团设备管理员", :roles => @fct_dvmgn, :factories => [@gysw])
#User.create!(:phone => "053766880606", :password => "zssw0606", :password_confirmation => "zssw0606", :name => "济宁中山公用水务仓库管理员", :roles => @fct_whmgn, :factories => [@zssw])
#User.create!(:phone => "053711115678", :password => "zssw5678", :password_confirmation => "zssw5678", :name => "济宁中山公用水务设备管理员", :roles => @fct_dvmgn, :factories => [@zssw])
#User.create!(:phone => "053700006666", :password => "gyrd6666", :password_confirmation => "gyrd6666", :name => "山东公用热电集团仓库管理员", :roles => @fct_whmgn, :factories => [@gyrd])
#User.create!(:phone => "053700009999", :password => "gyrd9999", :password_confirmation => "gyrd9999", :name => "山东公用热电集团设备管理员", :roles => @fct_dvmgn, :factories => [@gyrd])
#User.create!(:phone => "053766886969", :password => "gysy6969", :password_confirmation => "gysy6969", :name => "山东公用商业集团仓库管理员", :roles => @fct_whmgn, :factories => [@gysy])
#User.create!(:phone => "053766665656", :password => "gysy5656", :password_confirmation => "gysy5656", :name => "山东公用商业集团设备管理员", :roles => @fct_dvmgn, :factories => [@gysy])
#User.create!(:phone => "053798985858", :password => "gyhw5858", :password_confirmation => "gyhw5858", :name => "山东公用环卫集团仓库管理员", :roles => @fct_whmgn, :factories => [@gyhw]) 
#User.create!(:phone => "053737081111", :password => "gyhw1111", :password_confirmation => "gyhw1111", :name => "山东公用环卫集团设备管理员", :roles => @fct_dvmgn, :factories => [@gyhw]) 
#User.create!(:phone => "053766661818", :password => "gyjg1818", :password_confirmation => "gyjg1818", :name => "山东公用建工集团仓库管理员", :roles => @fct_whmgn, :factories => [@gyjg])
#User.create!(:phone => "053798986868", :password => "gyjg6868", :password_confirmation => "gyjg6868", :name => "山东公用建工集团设备管理员", :roles => @fct_dvmgn, :factories => [@gyjg])
#User.create!(:phone => "053798986666", :password => "jskj6666", :password_confirmation => "jskj6666", :name => "济宁金水科技仓库管理员", :roles => @fct_whmgn, :factories => [@jskj]) 
#User.create!(:phone => "053756788989", :password => "jskj8989", :password_confirmation => "jskj8989", :name => "济宁金水科技设备管理员", :roles => @fct_dvmgn, :factories => [@jskj]) 
#User.create!(:phone => "053798981919", :password => "gyzy1919", :password_confirmation => "gyzy1919", :name => "山东公用置业集团仓库管理员", :roles => @fct_whmgn, :factories => [@gyzy])
#User.create!(:phone => "053756781234", :password => "gyzy1234", :password_confirmation => "gyzy1234", :name => "山东公用置业集团设备管理员", :roles => @fct_dvmgn, :factories => [@gyzy])
