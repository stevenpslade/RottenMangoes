class Admin::UsersController < ApplicationController

  before_filter :restrict_access
  before_filter :admins_only

  def index
  end

end
