# Defines an invoice
class Invoice < ActiveRecord::Base
  validates :merchant_id, presence: true
  validates :status, presence: true

  has_many :invoice_items
  has_many :items, through: :invoice_items
  belongs_to :merchant

  def self.merchants
    Invoice.all.map(&:merchant).uniq
  end

  def self.status_percentages
    total = Invoice.count.to_f

    out = {
      pending: percentage('pending', total),
      shipped: percentage('shipped', total)
    }
    out[:returned] = 100 - out.values.sum

    out
  end

  def self.percentage(status, total)
    percentage = Invoice.where(status: status).count / total
    percentage *= 100
    percentage.round
  end

  def self.price_high_low
    highest = select('invoices.*, sum(unit_price * quantity) AS sum')
              .joins(:invoice_items)
              .group(:invoice_id, :id)
              .order('sum DESC')
              .first

    lowest = select('invoices.*, sum(unit_price * quantity) AS sum')
              .joins(:invoice_items)
              .group(:invoice_id, :id)
              .order('sum ASC')
              .first

    {
      highest: highest,
      lowest: lowest
    }
  end

  def self.quantity_high_low
    {
      highest: Invoice.new,
      lowest: Invoice.new
    }
  end
end
