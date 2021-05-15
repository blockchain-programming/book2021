class ApplicationController < ActionController::Base
  require 'bitcoin'
  helper_method :current_user, :current_finance, :current_wallet, :get_balance, :get_utxo, :logged_in?, :bitcoin_client

  def set_chain_params
    Bitcoin.chain_params = :regtest
  end

  private

  def current_user
    return unless session[:user_id]
    @current_user ||= User.find(session[:user_id])
  end

  def current_finance
    @current_finance = @current_user.finance
  end

  def current_wallet
    @current_wallet = @current_user.wallet
  end

  def logged_in?
    session[:user_id] == nil
  end

  def bitcoin_client
    config = {schema: 'http', host: 'localhost', port: 18443, user: 'aita', password: 'pass'}
    Bitcoin::RPC::BitcoinCoreClient.new(config)
  end

  def get_balance(wallet)
    @current_address = wallet.keys.find_by(wallet_id: wallet.id).address

    balance = 0
    bitcoin_client.listunspent.each do |utxo|
      if utxo['address'] == @current_address
        balance += utxo['amount']
      end
    end

    balance
  end

  def get_utxo(address)
    utxos = []
    bitcoin_client.listunspent.each do |utxo|
      if utxo['address'] == address
        utxos << utxo
      end
    end

    utxos
  end
end
