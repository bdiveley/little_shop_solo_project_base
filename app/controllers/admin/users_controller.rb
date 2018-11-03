class Admin::UsersController < ApplicationController
  before_action :require_admin

  def edit
    @user = User.find_by(slug: params[:slug])
  end

  def update
    @user = User.find_by(slug: params[:slug])
    if @user.update(user_params)
      flash[:success] = 'Profile data was successfully updated.'
      redirect_to user_path(@user)
    else
      render file: 'errors/not_found', status: 404
    end
  end

private
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name, :address, :city, :state, :zip, :slug)
  end

  def require_admin
    render file: "/public/404" unless current_admin?
  end
end
