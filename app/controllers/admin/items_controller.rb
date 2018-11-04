class Admin::ItemsController < ApplicationController
  before_action :require_admin

  def edit
    @item = Item.find_by(slug: params[:slug])
  end

  def update
    @item = Item.find_by(slug: params[:slug])
    if @item.update(item_params)
      flash[:success] = 'Item data was successfully updated.'
      redirect_to item_path(@item)
    elsif params[:slug] != params[:item][:slug]
      @item[:slug] = params[:slug]
      redirect_to edit_admin_item_path(@item), notice: "Slug has already been taken"
    else
      render :edit
    end
  end

private
  def item_params
    params.require(:item).permit(:user_id, :name, :description, :image, :price, :inventory, :slug)
  end

  def require_admin
    render file: "/app/views/errors/unacceptable" unless current_admin?
  end
end
