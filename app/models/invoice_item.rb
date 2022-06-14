class InvoiceItem < ApplicationRecord
  enum status: { 'pending' => 0, 'packaged' => 1, 'shipped' => 2 }

  before_create :add_discount
  belongs_to :invoice
  belongs_to :item
  validates_presence_of :status
  has_one :merchant, through: :item
  has_many :bulk_discounts, through: :merchant


  def self.incomplete_inv
    where(status: %w[pending packaged])
      .order(:created_at)
  end

  def self.discounted_revenue
    distinct.map do |invoice_item|
      invoice_item.add_discount
      if !invoice_item.bulk_discount_id.nil?
        discount = BulkDiscount.find(invoice_item[:bulk_discount_id])
        (invoice_item.quantity * invoice_item.unit_price * (100 - discount.percentage) / 100) / 100
      else
        (invoice_item.quantity * invoice_item.unit_price) / 100
      end
    end.sum
  end

  def add_discount
    bulk_discounts.order(threshold: :desc).each do |discount|
      self.bulk_discount_id = discount.id if quantity >= discount.threshold
      self.save
    end
  end

  def top_discount
    bulk_discounts.where('bulk_discount.threshold <= ?', quantity).order(percentage: :desc).limit(1)
  end
end
