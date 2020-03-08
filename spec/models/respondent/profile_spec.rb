require 'rails_helper'

describe Respondent::Profile do
  describe 'Associations' do
    it { should belong_to :respondent }
  end

  describe 'Validations' do
  end

  describe '#function' do
  end
end
