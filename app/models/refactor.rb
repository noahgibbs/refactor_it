class Refactor < ActiveRecord::Base
  belongs_to :snippet
  belongs_to :user
  has_many :votes

  validates_presence_of :snippet_id

  named_scope :most_recent, :order => "created_at DESC"
  named_scope :by_karma, :order => "karma DESC, created_at DESC"
  named_scope :limit, lambda { |num| { :limit => num } }

  VoteTypes = Vote::VoteTypes
  VoteTypesByNumber = Vote::VoteTypesByNumber
  Languages = Snippet::Languages

  def before_save
    self.body = self.body.strip
    self.language = Languages[self.language] || "Ruby"
  end

  def vote_for(user)
    Vote.find :first, :conditions => { :user_id => user.id,
                                       :refactor_id => self.id }
  end

  def has_vote_for?(user)
    !!vote_for(user)
  end

  def vote_type_for(user)
    v = vote_for(user)
    v ? VoteTypesByNumber[v.vote_type] : nil
  end

  def calculate_karma
    sql_results = Vote.connection.execute("SELECT vote_type, COUNT(*) FROM votes WHERE snippet_id = #{self.snippet.id} AND refactor_id = #{self.id} AND vote_approved = 1 AND user_id IS NOT NULL GROUP BY vote_type")

    total = 0
    sql_results.each do |row|
      vote_type = row['vote_type'].to_i
      count = row['COUNT(*)'].to_i

      if vote_type >= 2000  # spam or inappropriate
        total -= count * 5
      elsif vote_type >= 1000  # interesting or appropriate
        total += count
      else
        raise "Illegal value found in votes!"
      end
    end

    self.karma = total
  end
end
