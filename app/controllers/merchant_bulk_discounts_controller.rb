class MerchantBulkDiscountsController < ApplicationController
  before_action :next_holidays, only: %i[index]

  def index
    @merchant = Merchant.find(params[:merchant_id])
    @discounts = @merchant.bulk_discounts
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @discount = BulkDiscount.find(params[:id])
  end

  def edit
    @merchant = Merchant.find(params[:merchant_id])
    @discount = BulkDiscount.find(params[:id])
  end

  def update
    discount = BulkDiscount.find(params[:id])
    merchant = discount.merchant
    discount.update(bulk_discount_params)
    redirect_to merchant_bulk_discount_path(merchant, discount)
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    @discount = @merchant.bulk_discounts.create(bulk_discount_params)
    redirect_to merchant_bulk_discounts_path(@merchant.id)
  end

  def destroy
    discount = BulkDiscount.find(params[:id])
    discount.destroy
    redirect_to merchant_bulk_discounts_path(params[:merchant_id])
  end

  def next_holidays
    @holidays = HolidayFacade.summon_holidays
  end

  private

  def bulk_discount_params
    params.permit(:threshold, :percentage, :merchant_id)
  end
end
