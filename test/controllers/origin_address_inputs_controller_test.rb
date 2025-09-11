require "test_helper"

class OriginAddressInputsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get new_origin_address_input_url
    assert_response :success
  end

  test "should get create" do
    post origin_address_inputs_url, params: { origin_address: { address: "東京都千代田区丸の内1-9-1", lat: "35.6812", lng: "139.7671" } }
    assert_response :redirect
  end
end
