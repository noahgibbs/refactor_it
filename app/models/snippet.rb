class Snippet < ActiveRecord::Base
  has_many :refactors
  has_many :votes
end
