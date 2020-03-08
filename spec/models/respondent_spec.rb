require 'rails_helper'

describe Respondent do
  describe 'Associations' do
    it { should have_one :profile }
    it { should have_many :answers }
  end

  describe 'Validations' do
  end
end
