require "rails_helper"

RSpec.describe 'Admin-only item management' do
  before(:each) do
    @admin = create(:admin)
    @active_user = create(:user)
    @active_merchant = create(:merchant)
    @item = create(:item)
  end
  it 'allows admin access to a an item edit page through admin namespace' do
    visit login_path
    fill_in :email, with: @admin.email
    fill_in :password, with: @admin.password
    click_button 'Log in'

    visit items_path

    within("#item-#{@item.id}") do
      click_link "Edit Item"
    end

    expect(current_path).to eq(edit_admin_item_path(@item))

    visit item_path(@item)
    click_link "Edit"

    expect(current_path).to eq(edit_admin_item_path(@item))
  end

  it "allows admin to change  all atributes, including the slug for an item" do
    visit login_path
    fill_in :email, with: @admin.email
    fill_in :password, with: @admin.password
    click_button 'Log in'

    visit edit_admin_item_path(@item)

    fill_in :item_name, with: "New Name"
    fill_in :item_description, with: "New Description"
    fill_in :item_image, with: "https://cdn.arstechnica.net/wp-content/uploads/2012/08/Acer-Aspire-A5560-7414.png"
    fill_in :item_price, with: "150"
    fill_in :item_inventory, with: "25"
    fill_in :item_slug, with: "coolnewslug"
    click_button 'Update Item'

    expect(current_path).to eq('/items/coolnewslug')
    expect(page).to have_content("New Name")
    expect(page).to have_content("New Description")
    expect(page).to have_css("img[src='https://cdn.arstechnica.net/wp-content/uploads/2012/08/Acer-Aspire-A5560-7414.png']")
    expect(page).to have_content("Price: $150.00")
  end
  it 'should block updating if slug is not unique' do
    item_1 = create(:item)
    item_2 = create(:item)

    visit login_path
    fill_in :email, with: @admin.email
    fill_in :password, with: @admin.password
    click_button 'Log in'

    visit edit_admin_item_path(item_1)

    fill_in :item_slug, with: "coolnewslug"
    click_button 'Update Item'

    expect(current_path).to eq("/items/coolnewslug")

    visit edit_admin_item_path(item_2)

    fill_in :item_slug, with: "coolnewslug"
    click_button 'Update Item'

    expect(current_path).to eq("/admin/items/#{item_2.slug}/edit")
    expect(page).to have_content("Slug has already been taken")

    fill_in :item_slug, with: "uniqueslug"
    click_button 'Update Item'

    expect(current_path).to eq('/items/uniqueslug')
  end
end
