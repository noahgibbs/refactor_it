class Vote < ActiveRecord::Base
  belongs_to :snippet
  belongs_to :refactor
  belongs_to :user

  validates_presence_of :vote_approved
  validates_presence_of :vote_type
  validates_presence_of :user_id
  validates_presence_of :snippet_id

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

  def validate
    if !snippet_id
      errors.add("snippet_id", "must have a snippet ID!")
    end
    super
  end

  def after_save
    if refactor_id
      refactor.calculate_karma
      refactor.save
    else 
      snippet.calculate_karma
      snippet.save
    end
  end

end
