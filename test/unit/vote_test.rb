require 'test_helper'

class VoteTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "can have both snippet and refactor" do
    vote = Vote.new(:snippet_id => 7, :refactor_id => 3,
                    :user_id => 4, :vote_type => 1001,
                    :vote_approved => 1)
    assert vote.save
  end

  test "can have just snippet" do
    vote = Vote.new(:snippet_id => 7,
                    :user_id => 4, :vote_type => 1001,
                    :vote_approved => 1)
    assert vote.save
  end

  test "can't have no snippet" do
    vote = Vote.new(:refactor_id => 7,
                    :user_id => 4, :vote_type => 1001,
                    :vote_approved => 1)
    assert !vote.save
    assert_error_on("snippet_id", vote)
  end

end
