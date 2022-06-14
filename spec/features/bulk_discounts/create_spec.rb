require 'rails_helper'

RSpec.describe 'bulk discont create' do
  before :each do
    @merchant_1 = Merchant.create!(name: 'Brylan')
    @merchant_2 = Merchant.create!(name: 'Brylan')

    @bulk_discount_1 = BulkDiscount.create!(percentage:15, threshold:10, merchant_id:@merchant_1.id)
    @bulk_discount_2 = BulkDiscount.create!(percentage:25, threshold:12, merchant_id:@merchant_1.id)
    @bulk_discount_3 = BulkDiscount.create!(percentage:35, threshold:18, merchant_id:@merchant_1.id)
    @bulk_discount_4 = BulkDiscount.create!(percentage:30, threshold:20, merchant_id:@merchant_2.id)
  end


  scenario 'creating a bulk discount' do
    visit merchant_bulk_discounts_path(@merchant_1)

    click_on 'Create Bulk Discount'

    expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant_1))

    within '#new-threshold' do
      select(25)
    end

    within '#new-percentage' do
      select(5)
    end
    click_on 'Create'

    expect(current_path).to eq(merchant_bulk_discounts_path(@merchant_1))

    expect(page).to have_content('Percent Discount: 5')
    expect(page).to have_content('Item Quantity Threshold: 25')
  end
end
