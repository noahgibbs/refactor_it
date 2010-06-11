require 'test_helper'

class RefactorsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:refactors)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create refactor" do
    assert_difference('Refactor.count') do
      post :create, :refactor => { }
    end

    assert_redirected_to refactor_path(assigns(:refactor))
  end

  test "should show refactor" do
    get :show, :id => refactors(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => refactors(:one).to_param
    assert_response :success
  end

  test "should update refactor" do
    put :update, :id => refactors(:one).to_param, :refactor => { }
    assert_redirected_to refactor_path(assigns(:refactor))
  end

  test "should destroy refactor" do
    assert_difference('Refactor.count', -1) do
      delete :destroy, :id => refactors(:one).to_param
    end

    assert_redirected_to refactors_path
  end
end
