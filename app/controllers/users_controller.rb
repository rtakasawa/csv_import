class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def import
    # fileはtmpに自動で一時保存される
    User.import(params[:file])
    redirect_to users_url
  end
end
