class Admin::UsersController < ApplicationController

  before_filter :restrict_access
  before_filter :admins_only

  def index
    @users = User.all.page(params[:page]).per(10)
  end

  def show
    @user = User.find(params[:id])
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    # redirect_to admin_users_path

    respond_to do |format|
      if @user.destroy
        # Tell the UserMailer to send a goodbye email after save
        UserMailer.goodbye_email(@user).deliver_now
 
        format.html { redirect_to(admin_users_path, notice: "#{@user.firstname} was successfully deleted.") }
      end
    end
  end

end
