require 'test_helper'

class Api::V1::HealthcheckControllerTest < ActionDispatch::IntegrationTest
  test "should_retrieves_http_200_status_code" do
    get "/api/v1/healthcheck"
    assert_equal 200, status
  end
end
