require 'test_helper'

class CalendarControllerTest < ActionDispatch::IntegrationTest
  test "should get redirect" do
    get calendar_redirect_url
    assert_response :success
  end

end
