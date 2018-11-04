class Cart
  attr_reader :contents

  def initialize(initial_contents)
    @contents = initial_contents || Hash.new(0)
  end

  def total_count
    @contents.values.sum
  end

  def add_item(item_id)
    @contents[item_id.to_s] ||= 0
    @contents[item_id.to_s] += 1
  end

  def remove_item(item_id)
    item_id_str = item_id.to_s
    if @contents.key?(item_id_str)
      @contents[item_id.to_s] -= 1
      if @contents[item_id.to_s] <= 0
        @contents.delete(item_id.to_s)
      end
    end
  end

  def remove_all_item(item_id)
    item_id_str = item_id.to_s
    if @contents.key?(item_id_str)
      @contents.delete(item_id.to_s)
    end
  end

  def count_of(item_id)
    @contents[item_id.to_s].to_i
  end

  def grand_total
    total = 0
    Item.where(id: @contents.keys).each do |item|
      total += (price(item.id) * count_of(item.id))
    end
    total
  end

  def price(item_id)
    item = Item.find(item_id)
    if @contents[item_id.to_s] < 10
      item.price
    elsif @contents[item_id.to_s] >= 10 && @contents[item_id.to_s] < 20
      item.price * 0.95
    else
      item.price * 0.9
    end
  end
end
