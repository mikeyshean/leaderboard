class Leader < ActiveRecord::Base

  validates :name, :score, presence: true
end
