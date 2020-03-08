class Respondent < ApplicationRecord
  # Associations
  has_one :profile
  has_many :answers

  accepts_nested_attributes_for :profile
end
