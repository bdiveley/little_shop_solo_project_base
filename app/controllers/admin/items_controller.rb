class Admin::ItemsController < ApplicationController
  before_action :require_admin

  # def edit
  #   @item = Item.find_by(slug: params[:slug])
  # end

  # def update
  #   @user = User.find_by(slug: params[:slug])
  #   @user.update(user_params)
  #   flash[:success] = 'Profile data was successfully updated.'
  #   redirect_to user_path(@user)
  # end

private
  def item_params
    params.require(:item).permit(:user_id, :name, :description, :image, :price, :inventory)
  end

  def require_admin
    render file: "/public/404" unless current_admin?
  end
end
