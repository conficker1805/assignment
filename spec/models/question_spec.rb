require 'rails_helper'

describe Question, type: :model do
  describe 'Associations' do
    it { should have_many :answers }
  end

  describe 'Validations' do
  end
end
