require 'test_helper'

class GuildHallsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get guild_halls_show_url
    assert_response :success
  end

  test "should get new" do
    get guild_halls_new_url
    assert_response :success
  end

  test "should get edit" do
    get guild_halls_edit_url
    assert_response :success
  end

end
