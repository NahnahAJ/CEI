class Equipment < ApplicationRecord
  validates :year, :make, :model, :usage, :usage_type, :appraisal_date, presence: true
end
