class RoomsController < ApplicationController
  before_action :set_room, only: [:show, :edit, :update, :destroy]
  before_filter :room_change, only: :show
  after_action :room_change, only: :new
  before_action :authenticate_user!
  # GET /rooms
  # GET /rooms.json
  def index
    @rooms = Room.all
  end

  # GET /rooms/1
  # GET /rooms/1.json
  def show
    @rooms = Room.all
    @messages = @room.messages.order("created_at ASC")
    @users = User.where(room_id: @room.id)
    @current_user = current_user
  end

  # GET /rooms/new
  def new
    RoomChannel.broadcast_to current_user.room_id, remove: true, user_id: current_user.id
    current_user.leave_room
    @room = Room.new
  end

  # GET /rooms/1/edit
  def edit
  end

  # POST /rooms
  # POST /rooms.json
  def create
    @room = Room.new(room_params)
    respond_to do |format|
      if @room.save
        Room.all.each do |x|
          RoomChannel.broadcast_to x.id, addroom: true, message: RoomsController.render(partial: 'rooms/room', locals: {room: @room})
        end
        format.html { redirect_to @room, notice: 'Room was successfully created.' }
        format.json { render :show, status: :created, location: @room }
      else
        format.html { render :new }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rooms/1
  # PATCH/PUT /rooms/1.json
  def update
    respond_to do |format|
      if @room.update(room_params)
        format.html { redirect_to @room, notice: 'Room was successfully updated.' }
        format.json { render :show, status: :ok, location: @room }
      else
        format.html { render :edit }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rooms/1
  # DELETE /rooms/1.json
  def destroy
    @room.destroy
    respond_to do |format|
      format.html { redirect_to rooms_url, notice: 'Room was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_room
      if Room.all.empty?
        Room.create(name: "new room")
      end

      if Room.exists? id: params[:id]
        @room = Room.find(params[:id])
      else
        @room = Room.first
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def room_params
      params.require(:room).permit(:name)
    end

    def room_change
      if current_user
        RoomChannel.broadcast_to current_user.room_id, remove: true, user_id: current_user.id
        current_user.change_room(@room)
        RoomChannel.broadcast_to @room.id, add: true, message: RoomsController.render(partial: 'rooms/user', locals: {user: current_user})
      end
    end
end
