class Question < ApplicationRecord
  self.inheritance_column = "kind"
end
