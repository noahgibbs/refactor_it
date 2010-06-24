class Snippet < ActiveRecord::Base
  has_many :refactors
  has_many :votes
  belongs_to :user

  validates_presence_of :user_id

  Languages = {
    "C" => "c",
    "C++" => "c++",
    "CSS" => "css",
    "Dylan" => "dylan",
    "HTML" => "html",
    "Java" => "java",
    "JavaScript/ECMAScript" => "javascript",
    "JavaScript (jQuery)" => "jquery_javascript",
    "JavaScript (Prototype)" => "javascript_+_prototype",
    "Rails (Ruby)" => "ruby_on_rails",
    "Rails (HTML/Erb)" => "html_rails",
    "Rails (SQL)" => "sql_rails",
    "Ruby" => "ruby",
    "SQL" => "sql",
  }

  def before_save
    self.body = self.body.strip
    self.language = Languages[self.language] || "Ruby"
  end

  def calculate_karma
    sql_results = Vote.connection.execute("SELECT vote_type, COUNT(*) FROM votes WHERE snippet_id = #{self.id} AND refactor_id IS NULL AND vote_approved = 1 AND user_id IS NOT NULL GROUP BY vote_type")

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
