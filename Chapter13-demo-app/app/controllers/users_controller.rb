class UsersController < ApplicationController
  #before_action :current_user, only: [:home]

  def login_form
  end

  def home
    redirect_to login_path if logged_in?
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      redirect_to home_path
    else
      @user.save!
      render :new
    end
  end

  def login
    @user = User.find_by(email: params[:email], password: params[:password])
    if @user
      session[:user_id] = @user.id

      flash[:success] = "logged in!"
      redirect_to("/home")
    else
      flash[:danger] = "invalid email or password"
      render("users/login_form")
    end
  end

  def logout
    session[:user_id] = nil
    redirect_to("/home")
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:email, :password)
    end
end
