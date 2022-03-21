require "test_helper"

class GenerationControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get generation_index_url
    assert_response :success
  end
end
