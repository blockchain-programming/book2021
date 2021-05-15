class BlockchainController < ApplicationController
  before_action :bitcoin_client

  def home
    @blockchain_info = bitcoin_client.getblockchaininfo

    @exchange = User.find_by(is_admin: true)
    @exchange_wallet = @exchange.wallet
    @exchange_address = @exchange_wallet.keys.find_by(wallet_id: @exchange_wallet.id).address

    @utxos = bitcoin_client.listunspent

    @balance = get_balance(@exchange_wallet)

    @current_wallet = User.find(current_user.id).wallet
    @current_address = @current_wallet.keys.find_by(wallet_id: @current_wallet.id).address

    @current_user_utxos = get_utxo(@current_address)
    @exchange_utxos = get_utxo(@exchange_address)
  end

  def generate
    @exchange = User.find_by(is_admin: true)
    @exchange_wallet = @exchange.wallet
    @exchange_address = @exchange_wallet.keys.find_by(wallet_id: @exchange_wallet.id).address
    bitcoin_client.generatetoaddress(101, @exchange_address)

    flash[:info] = 'generated 101 blocks'
    redirect_to blockchain_home_path
  end

  def mining
    @exchange = User.find_by(is_admin: true)
    @exchange_wallet = @exchange.wallet
    @exchange_address = @exchange_wallet.keys.find_by(wallet_id: @exchange_wallet.id).address
    bitcoin_client.generatetoaddress(1, @exchange_address)

    flash[:info] = 'mined 1 block'
    redirect_to blockchain_home_path
  end
end
