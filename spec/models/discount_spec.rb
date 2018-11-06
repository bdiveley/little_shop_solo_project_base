require 'rails_helper'

RSpec.describe Discount, type: :model do
  describe 'Relationships' do
    it { should belong_to(:item) }
  end

  describe 'Validations' do
    it { should validate_presence_of :first_percent }
    it { should validate_presence_of :second_percent }
    it { should validate_presence_of :first_quantity }
    it { should validate_presence_of :second_quantity }
    it { should validate_numericality_of(:first_percent).is_greater_than_or_equal_to(0) }
    it { should validate_numericality_of(:second_percent).is_greater_than_or_equal_to(0) }
    it { should validate_numericality_of(:first_quantity).is_greater_than_or_equal_to(0) }
    it { should validate_numericality_of(:second_quantity).is_greater_than_or_equal_to(0) }
  end
end
