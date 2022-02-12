Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  resources :transactions, only: %i[index create show]

  root to: redirect('/api-docs')
end
