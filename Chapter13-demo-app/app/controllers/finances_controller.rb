class FinancesController < ApplicationController
  def new
    @finance = Finance.new
  end

  def create
    @user = User.find(current_user.id)
    @finance = @user.build_finance(finance_params)

    if @finance.save
      redirect_to finances_show_path
    else
      @finance.save!
      render :new
    end
  end

  def show
    @finance = Finance.find_by(user_id: current_user.id)
  end

  def destroy
  end

  def pre_deposit
    @user = User.find(current_user.id)

    if @user.finance != nil
      @finance = Finance.new
    else
      redirect_to finances_new_path
    end
  end

  def deposit
    @user = User.find(current_user.id)
    balance = @user.finance.fiat_jpy
    @finance = @user.finance.update_attribute(:fiat_jpy, balance + params[:deposit].to_i)
    redirect_to finances_show_path
  end

  private

  def finance_params
    params.require(:finance).permit(:branch_number, :account_number, :name)
  end
end
