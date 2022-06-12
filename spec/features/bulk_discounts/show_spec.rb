require 'rails_helper'

RSpec.describe 'discount show page', type: :feature do
  before :each do
    @merchant_1 = Merchant.create!(name: 'Brylan')
    @merchant_2 = Merchant.create!(name: 'Brylan')

    @bulk_discount_1 = BulkDiscount.create!(percentage:15, threshold:10, merchant_id:@merchant_1.id)
    @bulk_discount_2 = BulkDiscount.create!(percentage:10, threshold:12, merchant_id:@merchant_2.id)
  end

  it 'shows the information for a bulk discount' do
    visit merchant_bulk_discount_path(@merchant_1, @bulk_discount_1)

    within '#discount-info' do
      expect(page).to have_content('Discount Item Threshold: 10 items')
      expect(page).to have_content('Bulk Discount Percentage: 15.0%')
    end
  end

  it 'has a link to edit a merchant bulk discount' do
    visit merchant_bulk_discount_path(@merchant_1, @bulk_discount_1)

    within '#edit-link' do
      expect(page).to have_link('Edit Bulk Discount')
    end

    click_on 'Edit Bulk Discount'
    expect(current_path).to eq(edit_merchant_bulk_discount_path(@merchant_1, @bulk_discount_1))
  end
end
