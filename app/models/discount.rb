class Discount < ApplicationRecord
  belongs_to :item

  validates :percent_off, presence: true, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0
  }
  validates :quantity, presence: true, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0
  }

  def percentage
    1 - percent_off/100.00
  end
end
