class Respondent
  class Profile < ApplicationRecord
    extend Enumerize
    enumerize :gender, in: %w[Male Female]

    # Associtations
    belongs_to :respondent
  end
end
