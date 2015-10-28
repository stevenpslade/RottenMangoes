class Admin::UsersController < ApplicationController

  before_filter :restrict_access
  before_filter :admins_only

  def index
    @users = User.all.page(params[:page]).per(10)
  end

  def show
    @user = User.find(params[:id])
  end

end
