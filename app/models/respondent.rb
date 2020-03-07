class Respondent < ApplicationRecord
  has_one :profile

  accepts_nested_attributes_for :profile
end
