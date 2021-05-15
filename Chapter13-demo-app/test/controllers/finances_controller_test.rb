require 'test_helper'

class FinancesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get finances_new_url
    assert_response :success
  end

  test "should get create" do
    get finances_create_url
    assert_response :success
  end

  test "should get show" do
    get finances_show_url
    assert_response :success
  end

  test "should get destroy" do
    get finances_destroy_url
    assert_response :success
  end

end
