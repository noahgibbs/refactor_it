class Refactor < ActiveRecord::Base
  belongs_to :snippet
  belongs_to :user
  has_many :votes

  validates_presence_of :snippet_id

  Languages = Snippet::Languages

  def before_save
    self.body = self.body.strip
    self.language = Languages[self.language] || "Ruby"
  end
end
