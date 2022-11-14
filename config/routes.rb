Rails.application.routes.draw do
  root :to => 'qes_banks#index'

  #mount Ckeditor::Engine => '/ckeditor'
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  #get 'forget', to: 'admin/dashboard#index'
  #devise_for :users, controllers: { registrations: 'users/registrations', sessions: 'users/sessions' }
  devise_for :users, controllers: { sessions: 'users/sessions' }
  devise_scope :user do
    #get 'forget', to: 'users/passwords#forget'
    #patch 'update_password', to: 'users/passwords#update_password'
    #post '/login_validate', to: 'users/sessions#user_validate'
    #
    #unauthenticated :user do
    #  root to: "devise/sessions#new",as: :unauthenticated_root #设定登录页为系统默认首页
    #end
    #authenticated :user do
    #  root to: "homes#index",as: :authenticated_root #设定系统登录后首页
    #end
  end

  #resources :users, :only => []  do
  #  get :center, :on => :collection
  #  get :alipay_return, :on => :collection
  #  post :alipay_notify, :on => :collection
  #  get :mobile_authc_new, :on => :member
  #  post :mobile_authc_create, :on => :member
  #  get :mobile_authc_status, :on => :member
  #end

  resources :roles

  #resources :accounts, :only => [:edit, :update] do
  #  get :recharge, :on => :collection 
  #  get :info, :on => :collection
  #  get :status, :on => :collection
  #end

  require 'sidekiq/web'
  require 'sidekiq/cron/web'
  mount Sidekiq::Web => '/wcnmngsbsidekiq'

  resources :properties
  resources :nests 
  resources :domains 

  resources :controls, :only => [:index] do
    get :search, :on => :collection
  end
  resources :templates do
    get :produce, :on => :member
  end

  #resources :nlps do
  #  collection do
  #    post 'analyze'
  #  end
  #end
  #resources :ocrs do
  #  post :analyze, :on => :collection
  #end

  #resources :systems, :only => [] do
  #  get :send_confirm_code, :on => :collection
  #end
  #
  #resources :orders, :only => [:new, :create] do
  #  get :pay, :on => :collection
  #  get :alipay_return, :on => :collection
  #  post :alipay_notify, :on => :collection
  #end

  #resources :tasks, :only => [] do
  #  get :invite, :on => :collection
  #end

  #resources :spiders do
  #  get :start, :on => :member
  #end

  resources :selectors
 
  #resources :factories, :only => [] do
  #  #get :bigscreen, :on => :member
  #  #resources :students do
  #  #  post :parse_excel, :on => :collection
  #  #  get :xls_download, :on => :collection
  #  #end
  #end
  #resources :departments do
  #  get :download_append, :on => :member
  #  post :parse_excel, :on => :collection
  #  get :xls_download, :on => :collection
  #end
  #resources :error_logs, :only => [:index] do
  #  get :download, :on => :member
  #end
  #resources :articles do
  #  get :export, :on => :collection
  #  get :main_image, :on => :member
  #  get :detail_image, :on => :member
  #end

  resources :students, :only => [] do
    get :all, :on => :collection
  end
  resources :papers do
    get :download_append, :on => :member
    get :download_paper, :on => :member
    get :xls_download, :on => :collection
    get :query_all, :on => :collection
  end
  resources :qes_banks do
    get :query_all, :on => :collection
    get :query_lib_all, :on => :collection
    resources :singles, :only => [:index, :destroy]  do
      post :parse_excel, :on => :collection
      get :xls_download, :on => :collection
    end
    resources :mcqs, :only => [:index, :destroy]  do
      post :parse_excel, :on => :collection
      get :xls_download, :on => :collection
    end
    resources :tofs, :only => [:index, :destroy]  do
      post :parse_excel, :on => :collection
      get :xls_download, :on => :collection
    end
    resources :qaas, :only => [:index, :destroy]  do
      post :parse_excel, :on => :collection
      get :xls_download, :on => :collection
    end
  end
  resources :essays do
    get :download_append, :on => :member
  end
  resources :laws do
    get :download_append, :on => :member
    get :query_all, :on => :collection
  end
  resources :advises, :only => [:index, :show, :destroy] do
    get :query_all, :on => :collection
  end
  resources :notices do
    get :download_attachment, :on => :member
    get :download_append, :on => :member
    get :query_all, :on => :collection
  end
  resources :learn_ctgs do
    get :query_all, :on => :collection
  end
  resources :law_ctgs do
    get :query_all, :on => :collection
  end

  resources :wx_essays, :only => [] do
    get :query_all, :on => :collection
    get :query_show, :on => :collection
  end
  resources :wx_advises, :only => []  do
    post :create_advise, :on => :collection
  end
  resources :wx_learnctgs, :only => []  do
    get :query_all, :on => :collection
    get :qes_bank, :on => :collection
  end

  resources :wx_users, only: [:update] do
    collection do
      post 'get_userid'
      get 'fcts'
      get 'status'
      post 'set_fct'
    end
  end
  
  resources :wx_notices, :only => []  do
    collection do
      get 'query_latest'
      get 'query_show'
    end
  end
  resources :wx_qesbanks, :only => []  do
    collection do
      get 'query_all'
      get 'single_query_all'
      get 'mcq_query_all'
      get 'tof_query_all'
      get 'qaa_query_all'
      get 'query_lib_all'
    end
  end
  resources :wx_lawctgs, :only => []  do
    collection do
      get 'query_all'
      get 'qes_bank'
      get 'query_show'
    end
    get :download_append, :on => :member
  end

  resources :flower

end
