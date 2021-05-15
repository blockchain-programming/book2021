require 'test_helper'

class ExchangesControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get exchanges_create_url
    assert_response :success
  end

end
