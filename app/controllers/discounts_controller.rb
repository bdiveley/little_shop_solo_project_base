class DiscountsController < ApplicationController

  def index
    @item = Item.find_by(slug: params[:item_slug])
    @discounts = Discount.where(item: @item)
  end

  def new
    @item = Item.find_by(slug: params[:item_slug])
    @discount = Discount.new()
  end

  def create
    render file: 'errors/not_found', status: 404 if current_user.nil?
    @item = Item.find_by(slug: params[:item_slug])
    @item.discounts.create(discount_params)
    flash[:success] = "Discount created"
    redirect_to item_discounts_path(@item)
  end

  private

  def discount_params
    params.require(:discount).permit(:percent_off, :quantity)
  end
end
