class RoomsController < ApplicationController
  before_action :set_room, only: [:show, :edit, :update]
  before_action :authenticate_user!, except: [:show]
  
  def index
    @rooms = current_user.rooms
  end

  def show
    @photos = @room.photos
  end

  def new
    @room = current_user.rooms.build
  end

  def create
    @room = current_user.rooms.build(room_params)
    if @room.save
      if params[:images]
        params[:images].each do |img|
          @room.photos.create(image: img)
        end
      end
      
      @photos = @room.photos
      redirect_to edit_room_path(@room), notice: "Saved..."
    else
      flash[:alert] = "Please provide all information required."
      render :new
    end
  end

  def edit
    if current_user.id == @room.user_id
      @photos = @room.photos
    else
      redirect_to root_path, notice: "You don't have permission to do that."
    end
  end

  def update
    if @room.update(room_params)
      if params[:images]
        params[:images].each do |img|
          @room.photos.create(image: img)
        end
      end
      redirect_to edit_room_path(@room), notice: "Updated..."
    else
      flash[:alert] = "Please provide all information required."
      render :edit
    end
  end
  
  private
  def set_room
    @room = Room.find(params[:id])
  end
  
  def room_params
    params.require(:room).permit(:home_type, :room_type, :accommodate, :bed_room, :bath_room, :listing_name, :summary, :address, :is_tv, :is_kitchen, :is_smoking, :is_air, :is_heating, :is_internet, :is_gym, :is_pool, :price, :active)
  end
end
