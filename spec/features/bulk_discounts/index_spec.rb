require 'rails_helper'

RSpec.describe 'bulk discont Index' do
before :each do
  @merchant_1 = Merchant.create!(name: 'Brylan')
  @merchant_2 = Merchant.create!(name: 'Brylan')

  @bulk_discount_1 = BulkDiscount.create!(percentage:15, threshold:10, merchant_id:@merchant_1.id)
  @bulk_discount_2 = BulkDiscount.create!(percentage:25, threshold:12, merchant_id:@merchant_1.id)
  @bulk_discount_3 = BulkDiscount.create!(percentage:10, threshold:15, merchant_id:@merchant_1.id)
  @bulk_discount_4 = BulkDiscount.create!(percentage:30, threshold:20, merchant_id:@merchant_2.id)
end

  it 'lists names of all merchant bulk discounts', :vcr do
    visit merchant_dashboard_index_path(@merchant_1)
    within '#discounts-link' do
      click_on 'View All Discounts'
    end

    expect(current_path).to eq(merchant_bulk_discounts_path(@merchant_1))

    within "#discount-#{@bulk_discount_1.id}" do
      expect(page).to have_content(@bulk_discount_1.percentage)
      expect(page).to have_content(@bulk_discount_1.threshold)
      expect(page).to have_link('Bulk Discount Show Page')
    end

    within "#discount-#{@bulk_discount_2.id}" do
      expect(page).to have_content(@bulk_discount_2.percentage)
      expect(page).to have_content(@bulk_discount_2.threshold)
      expect(page).to have_link('Bulk Discount Show Page')
    end

    within "#discount-#{@bulk_discount_3.id}" do
      expect(page).to have_content(@bulk_discount_3.percentage)
      expect(page).to have_content(@bulk_discount_3.threshold)
      expect(page).to have_link('Bulk Discount Show Page')
    end

    expect(page).to_not have_content(@bulk_discount_4.percentage)
    expect(page).to_not have_content(@bulk_discount_4.threshold)
  end

  scenario 'displays link to a bulk discount creation form' do
    visit merchant_bulk_discounts_path(@merchant_1)

    click_on 'Create Bulk Discount'

    expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant_1))

    within '#new-threshold' do
      select(10)
    end

    within '#new-percentage' do
      select(15)
    end

    click_on 'Create'

    expect(current_path).to eq(merchant_bulk_discounts_path(@merchant_1))
  end
end
