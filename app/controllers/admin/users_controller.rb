class Admin::UsersController < ApplicationController

  before_filter :admin_only
  before_filter :restrict_access

  def index
    @users = User.all.page(params[:page]).per(5)
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    UserMailer.delete_user(@user).deliver
    redirect_to admin_users_path, notice: "#{@user.firstname + " " + @user.lastname} was deleted."
  end

end