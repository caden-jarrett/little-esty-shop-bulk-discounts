class InvoiceItem < ApplicationRecord
  enum status: { 'pending' => 0, 'packaged' => 1, 'shipped' => 2 }

  belongs_to :invoice
  belongs_to :item
  validates_presence_of :status
  has_one :merchant, through: :item
  has_many :bulk_discounts, through: :merchant

  before_create :add_discount

  def self.incomplete_inv
    where(status: %w[pending packaged])
      .order(:created_at)
  end

  def self.discounted_revenue
    distinct.map do |invoice_item|
      invoice_item.discount_cost
    end.sum
  end

  def discount_cost
    if !bulk_discount_id.nil?
      discount = BulkDiscount.find(bulk_discount_id)
      (quantity * unit_price * (100 - discount.percentage) / 100) / 100
    else
      (quantity * unit_price) / 100
    end
  end

  def add_discount
    bulk_discounts.order(percentage: :desc).each do |discount|
      self.bulk_discount_id = discount.id if quantity >= discount.threshold
      break
    end
  end
end
