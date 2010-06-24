class Snippet < ActiveRecord::Base
  has_many :refactors
  has_many :votes
  belongs_to :user

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
end
