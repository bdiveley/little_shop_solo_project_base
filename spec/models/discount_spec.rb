require 'rails_helper'

RSpec.describe Discount, type: :model do
  describe 'Relationships' do
    it { should belong_to(:item) }
  end

  describe 'Validations' do
    it { should validate_presence_of :percent_off }
    it { should validate_presence_of :quantity }
    it { should validate_numericality_of(:percent_off).is_greater_than_or_equal_to(0) }
    it { should validate_numericality_of(:quantity).is_greater_than_or_equal_to(0) }
  end
end
