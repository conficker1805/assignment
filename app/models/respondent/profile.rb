class Respondent
  class Profile < ApplicationRecord
    belongs_to :respondent

    extend Enumerize
    enumerize :gender, in: %w[Male Female]
  end
end
