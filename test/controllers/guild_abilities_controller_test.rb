require 'test_helper'

class GuildAbilitiesControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get guild_abilities_show_url
    assert_response :success
  end

  test "should get new" do
    get guild_abilities_new_url
    assert_response :success
  end

  test "should get edit" do
    get guild_abilities_edit_url
    assert_response :success
  end

end
