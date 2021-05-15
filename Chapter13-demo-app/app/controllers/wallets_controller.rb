class WalletsController < ApplicationController
  require 'bitcoin'

  before_action :set_chain_params

  def new
    @wallet = Wallet.new
  end

  def create
    @user = User.find(current_user.id)
    if Wallet.find_by(user_id: @user.id) == nil
      @wallet = @user.build_wallet(user_id: @user.id)
      if @wallet.save
        #@bitcoin_wallet = Bitcoin::Wallet::Base.create(wallet_id=@wallet.id)
      else
        @wallet.save!
      end
    end

    redirect_to keys_new_path
  end

  def show
    @user = User.find(current_user.id)
    @wallet = @user.wallet
  end

  def edit

  end

  def destroy

  end

  private

  def wallet_params
    params.require(:wallet).permit(:name)
  end
end
