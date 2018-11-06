class DiscountsController < ApplicationController

  def index
    @discounts = Discount.all
    @item = Item.find_by(slug: params[:item_slug])
  end

  def new
  end 
end
