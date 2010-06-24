require 'test_helper'

class VoteTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "can have both snippet and refactor" do
    vote = Vote.new(:snippet_id => snippets(:two).id,
                    :refactor_id => refactors(:two).id,
                    :user_id => 4, :vote_type => 1001,
                    :vote_approved => 1)
    assert vote.save
  end

  test "can have just snippet" do
    vote = Vote.new(:snippet_id => snippets(:one).id,
                    :user_id => 4, :vote_type => 1001,
                    :vote_approved => 1)
    assert vote.save
  end

  test "can't have no snippet" do
    vote = Vote.new(:refactor_id => refactors(:two).id,
                    :user_id => 4, :vote_type => 1001,
                    :vote_approved => 1)
    assert !vote.save
    assert_error_on("snippet_id", vote)
  end

  test "calculate snippet karma after save" do
    vote = Vote.new(:snippet_id => snippets(:phpsux).id,
                    :user_id => users(:sammy),
                    :vote_type => 2002, :vote_approved => 1)
    assert vote.save
    s = snippets(:phpsux)
    s.reload
    assert_equal -5, s.karma
  end

  test "calculate refactor karma after save" do
    vote = Vote.new(:snippet_id => snippets(:phpsux).id,
                    :refactor_id => refactors(:phprefactor).id,
                    :user_id => users(:sammy),
                    :vote_type => 2002, :vote_approved => 1)
    assert vote.save
    r = refactors(:phprefactor)
    r.reload
    assert_equal -5, r.karma
  end

end
