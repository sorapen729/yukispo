require "test_helper"

class OriginSelectionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get new_origin_selection_url
    assert_response :success
  end
end
