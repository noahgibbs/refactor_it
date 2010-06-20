class Vote < ActiveRecord::Base
  belongs_to :snippet
  belongs_to :refactor

  VoteTypes = {
    "Unvote" => 1,

    "Interesting" => 1001,
    "Difficult" => 1002,

    "Not Code" => 2001,
    "Spam" => 2002
  }

  VoteTypesByNumber = {}
  VoteTypes.each { |key, val| VoteTypesByNumber[val] = key }

  VoteTypeNames = (VoteTypes.keys - ["Unvote"]).sort {|a,b|
    VoteTypes[a] <=> VoteTypes[b]
  }

end
