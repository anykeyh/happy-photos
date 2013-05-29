require 'test_helper'

class PictureControllerControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get upload" do
    get :upload
    assert_response :success
  end

  test "should get remove" do
    get :remove
    assert_response :success
  end

end
