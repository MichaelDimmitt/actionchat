class RoomChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    if current_user.room_id == nil
      listen("room_id" => Room.last.id)
      current_user.change_room(Room.last)
    else
      listen("room_id" => current_user.room_id)
    end
  end

  def unsubscribed
      # Any cleanup needed when channel is unsubscribed
    RoomChannel.broadcast_to current_user.room_id, remove: true, user_id: current_user.id
    current_user.leave_room
  end

  def listen(data)
    stop_all_streams
    stream_for data["room_id"]
  end
end
