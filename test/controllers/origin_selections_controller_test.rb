require "test_helper"

class OriginSelectionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get origin_selections_new_url
    assert_response :success
  end
end
