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
    elsif params[:slug] != params[:user][:slug]
      @user[:slug] = params[:slug]
      redirect_to edit_admin_user_path(@user), notice: "Slug has already been taken"
    else
      redirect_to edit_admin_user_path(@user), notice: "Email has already been taken"
    end
  end

private
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name, :address, :city, :state, :zip, :slug)
  end

  def require_admin
    render file: "/app/views/errors/unacceptable" unless current_admin?
  end
end
