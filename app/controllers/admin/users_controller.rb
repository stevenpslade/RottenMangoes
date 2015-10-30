class Admin::UsersController < ApplicationController

  before_filter :restrict_access
  # before_filter :admins_only

  def index
    @users = User.all.page(params[:page]).per(10)
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update_attributes(user_params)
      redirect_to admin_user_path(@user)
    else
      render :edit
    end
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to movies_path
    else
      render :new
    end
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

  def impersonate
    session[:admin_user_id] = current_user.id 
    session[:user_id] = params[:id]
    redirect_to :root
  end

  def restore
    session[:user_id] = session[:admin_user_id] 
    session[:admin_user_id] = nil
    redirect_to :root
  end

  def user_params
    params.require(:user).permit(:email, :firstname, :lastname, :password, :password_confirmation, :admin)
  end

end
