require 'rails_helper'

RSpec.describe 'discount show page', type: :feature do
  before :each do
    @merchant_1 = Merchant.create!(name: 'Brylan')
    @merchant_2 = Merchant.create!(name: 'Ray')

    @bulk_discount_1 = BulkDiscount.create!(percentage:15, threshold:10, merchant_id:@merchant_1.id)
    @bulk_discount_2 = BulkDiscount.create!(percentage:10, threshold:12, merchant_id:@merchant_1.id)
    @bulk_discount_3 = BulkDiscount.create!(percentage:25, threshold:16, merchant_id:@merchant_1.id)
    @bulk_discount_4 = BulkDiscount.create!(percentage:20, threshold:8, merchant_id:@merchant_2.id)
  end

  it 'can edit a merchant bulk_discount' do
    visit merchant_bulk_discount_path(@merchant_1, @bulk_discount_1)

    click_on 'Edit Bulk Discount'

    expect(current_path).to eq(edit_merchant_bulk_discount_path(@merchant_1, @bulk_discount_1))

    within '#new-threshold' do
      select(5)
    end

    within '#new-percentage' do
      select(25)
    end

    click_on 'Update Bulk Discount'

    expect(current_path).to eq(merchant_bulk_discount_path(@merchant_1, @bulk_discount_1))
    save_and_open_page
    within "#discount-info" do
      expect(page).to have_content('Bulk Discount Percentage: 25.0%')
      expect(page).to have_content('Discount Item Threshold: 5')
    end
  end
end
