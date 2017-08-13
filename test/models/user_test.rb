require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "Example User", email: "user@example.com")
  end

  test "User name must be unique" do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
  end

  test "Change room should set room" do
    @user.change_room(Room.first)
    assert_equal @user.room_id, Room.first.id
  end

  test "Leave room should leave room" do
    @user.change_room(Room.first)
    assert_equal @user.room_id, Room.first.id
    @user.leave_room
    assert_nil @user.room_id
  end
end
