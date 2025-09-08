require "test_helper"

class OriginAddressInputControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get origin_address_input_new_url
    assert_response :success
  end

  test "should get create" do
    get origin_address_input_create_url
    assert_response :success
  end
end
