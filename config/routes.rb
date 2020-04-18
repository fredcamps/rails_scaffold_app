Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace 'api' do
    namespace 'v1' do
      get 'healthcheck', action: 'index', controller: 'healthcheck'
      get 'dns_records/:page', action: 'list', controller: 'dns_records'
      post 'dns_records', action: 'create', controller: 'dns_records'
    end
  end
end
