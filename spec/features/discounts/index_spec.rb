require "rails_helper"

RSpec.describe 'Discount Index Page, only for merchants' do
  context 'As a merchant user' do
    before(:each) do
      @merchant = create(:merchant)
      @item = @merchant.items.create(name: "Item 1", description: "Description", price: 5, inventory: 30)
      @discount = @item.discounts.create(percent_off: 5, quantity: 10)
      @discount_2 = @item.discounts.create(percent_off: 10, quantity: 20)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
    end

    it 'should show all discounts' do
      visit item_discounts_path(@item)

      within "#discount-#{@discount.id}" do
        expect(page).to have_content("When a buyer purchases at least #{@discount.quantity} items, the item price is discounted by #{@discount.percent_off}%")
      end
      within "#discount-#{@discount_2.id}" do
        expect(page).to have_content("When a buyer purchases at least #{@discount_2.quantity} items, the item price is discounted by #{@discount_2.percent_off}%")
      end
    end
    it 'should show a link to to add a discount' do
      visit item_discounts_path(@item)

        expect(page).to have_link("Add New Discount")
        click_link "Add New Discount"
      expect(current_path).to eq(new_item_discount_path(@item))
    end
  end
end
