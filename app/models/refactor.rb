class Refactor < ActiveRecord::Base
  belongs_to :snippet
  has_many :votes
end
