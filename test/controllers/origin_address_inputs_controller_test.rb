require "test_helper"

class OriginAddressInputsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get new_origin_address_inputs_url
    assert_response :success
  end

  test "should get create" do
    get origin_address_inputs_url
    assert_response :success
  end
end
