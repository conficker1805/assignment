class Question < ApplicationRecord
  attr_accessor :avg

  extend Enumerize

  self.inheritance_column = "kind"

  has_many :answers, class_name: 'Respondent::Answer'

  enumerize :type, in: %w[scored open-ended], scope: :shallow
end
