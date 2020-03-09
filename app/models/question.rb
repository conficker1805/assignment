class Question < ApplicationRecord
  attr_accessor :avg

  extend Enumerize

  self.inheritance_column = 'kind'

  has_many :answers, class_name: 'Respondent::Answer'

  enumerize :type, in: %w[scored open_ended], scope: :shallow, predicates: true

  scope :required, -> { where(optional: false) }
end
