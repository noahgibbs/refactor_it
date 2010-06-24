class Refactor < ActiveRecord::Base
  belongs_to :snippet
  has_many :votes

  Languages = Snippet::Languages

  def before_save
    self.body = self.body.strip
    self.language = Languages[self.language] || "Ruby"
  end
end
