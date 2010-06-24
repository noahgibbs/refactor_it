require 'test_helper'

class VoteTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "can't have both snippet and refactor" do
    vote = Vote.new(:snippet_id => 7, :refactor_id => 3,
                    :user_id => 4)
    assert !vote.save
    assert_error_on(:snippet_id, vote)
  end
end
