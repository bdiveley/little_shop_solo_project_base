class Item < ApplicationRecord
  belongs_to :user
  has_many :order_items
  has_many :orders, through: :order_items
  has_many :discounts

  validates_presence_of :name, :description
  validates :price, presence: true, numericality: {
    only_integer: false,
    greater_than_or_equal_to: 0
  }
  validates :inventory, presence: true, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0
  }
  validates :slug, uniqueness: true


  before_create :generate_slug

  def self.popular_items(quantity)
    select('items.*, sum(order_items.quantity) as total_ordered')
      .joins(:orders)
      .where('orders.status != ?', :cancelled)
      .where('order_items.fulfilled = ?', true)
      .group('items.id, order_items.id')
      .order('total_ordered desc')
      .limit(quantity)
  end

  def to_param
    slug
  end

  def ordered_discounts
    discounts.order(quantity: :asc)
  end 

private

  def generate_slug
    loop do
      self.slug = name.parameterize + rand(1000..9999).to_s
      break unless Item.where(slug: self.slug).exists?
    end
  end
end
