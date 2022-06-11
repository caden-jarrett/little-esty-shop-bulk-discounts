require 'rails_helper'

RSpec.describe 'index show page', type: :feature do
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
end
