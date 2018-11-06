class Discount < ApplicationRecord
  belongs_to :item

  validates :first_percent, presence: true, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0
  }
  validates :second_percent, presence: true, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0
  }
  validates :first_quantity, presence: true, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0
  }
  validates :second_quantity, presence: true, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0
  }


end
