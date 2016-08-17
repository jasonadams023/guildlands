require 'test_helper'

class UnitAbilitiesControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get unit_abilities_show_url
    assert_response :success
  end

  test "should get new" do
    get unit_abilities_new_url
    assert_response :success
  end

  test "should get edit" do
    get unit_abilities_edit_url
    assert_response :success
  end

end
