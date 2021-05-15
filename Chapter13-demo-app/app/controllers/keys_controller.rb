class KeysController < ApplicationController
  require 'bitcoin'

  before_action :set_chain_params

  def new
    @user = User.find(current_user.id)
    @wallet = @user.wallet
    @key = @wallet.keys.build

    # Error: already held by process
    # because leveldb has only a single process
    # @bitcoin_wallet.close not working?
    # @bitcoin_wallet = Bitcoin::Wallet::Base.load(@wallet.id)
    # @bitcoin_wallet = Bitcoin::Wallet::Base.current_wallet
    @bitcoin_wallet = Bitcoin::Wallet::Base.create(wallet_id = @wallet.id)

    # @bitcoin_account = @bitcoin_wallet.accounts[0]
    @bitcoin_account = @bitcoin_wallet.master_key.key.derive(84, true).derive(1, true).derive(0, true)
    # if use @receive_key = @bitcoin_account.derive_receive_keys[0] => Bitcoin::ExtPubkey
    # @receive_key => Bitcoin::ExtKey
    @receive_key = @bitcoin_account.derive(0).derive(0)
    @key.address = @receive_key.addr
    # export by hex
    @key.public_key = @receive_key.key.pubkey
    # export by Base58
    @key.private_key = @receive_key.key.to_wif

    if @key.save
      bitcoin_client.importaddress(@key.address)

      flash[:success] = 'Succeeded saving'
      redirect_to wallets_show_path
    else
      @key.save!
      flash[:danger] = 'Failed saving'
      redirect_to wallets_show_path
    end
  end

  def destroy
    @key = Key.find(2)
    @key.destroy

    redirect_to home_path
  end
end