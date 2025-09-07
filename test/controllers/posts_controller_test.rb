require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    skip "not implemented yet"
    get posts_index_url
    assert_response :success
  end
end
