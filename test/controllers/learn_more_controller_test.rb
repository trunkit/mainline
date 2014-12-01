require 'test_helper'

class LearnMoreControllerTest < ActionController::TestCase
  test "should get learn_trunksale" do
    get :learn_trunksale
    assert_response :success
  end

end
