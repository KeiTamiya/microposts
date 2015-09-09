class UsersController < ApplicationController
  
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.page(params[:page])
  end
  
  def new
    @user = User.new
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update(profile_params)
      redirect_to @user, notice: 'プロフィールを変更しました'
    else
      render 'edit'
    end
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def followings
    @user = User.find(params[:id])
    @following_users = @user.following_users
  end
  
  def followers
    @user = User.find(params[:id])
    @follower_users = @user.follower_users
  end
  
  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :profile, :area)
  end
  def profile_params
    params.require(:user).permit(:name, :email, :password, :profile, :area)
  end
end