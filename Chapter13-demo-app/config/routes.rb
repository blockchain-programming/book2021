Rails.application.routes.draw do
  get '' => 'users#index'
  get 'index' => 'users#index'

  get 'login' => 'users#login_form'
  post 'login' => 'users#login'
  get 'signup' => 'users#new'
  post 'signup' => 'users#create'
  delete 'logout' => 'users#logout'
  get 'home' => 'users#home'

  get 'wallets/new' => 'wallets#create'
  get 'wallets/show'

  get 'keys/new'
  get 'keys/delete' => 'keys#destroy'

  get 'finances/new'
  post 'finances/new' => 'finances#create'
  get 'finances/show'
  get 'finances/destroy'
  get 'finances/deposit' => 'finances#pre_deposit'
  post 'finances/deposit'

  get 'exchanges/jpy' => 'exchanges#new_jpy_to_bitcoin'
  post 'exchanges/jpy' => 'exchanges#create_jpy_to_bitcoin'
  get 'exchanges/btc' => 'exchanges#new_bitcoin_to_jpy'
  post 'exchanges/btc' => 'exchanges#create_bitcoin_to_jpy'

  get 'blockchain/home'
  get 'blockchain/generate' => 'blockchain#generate'
  get 'blockchain/mining'
end
