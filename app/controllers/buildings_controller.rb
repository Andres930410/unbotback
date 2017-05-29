class BuildingsController < ApplicationController
  before_action :set_building, only: [:show, :update, :destroy]

  # GET /buildings
  def index
    @buildings = Building.all

    render json: @buildings
  end

  # GET /buildings/1
  def show
    render json: @building
  end

  # POST /buildings
  def create
    @building = Building.new(building_params)

    if @building.save
      render json: @building, status: :created, location: @building
    else
      render json: @building.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /buildings/1
  def update
    if @building.update(building_params)
      render json: @building
    else
      render json: @building.errors, status: :unprocessable_entity
    end
  end

  # DELETE /buildings/1
  def destroy
    @building.destroy
  end

  def location
    entities = params["data"]
    is_correct = false
    entities.each do |e|
      if is_correct
        break
      end
      type = e["type"]
      case type
      when "building::nickname"
        v = e["entity"]
        is_correct = true
        @value = Building.building_by_nickname(v)
      when "builtin.number"
        v = e["resolution"]["value"]
        is_correct = true
        @value = Building.building_by_number(v)
      when "building::name"
        v = e["entity"]
        is_correct = true
        @value = Building.building_by_name(v)
      end
    end
    if @value
      render json: data: {
        status: "ok",
        data: @value.to_json
      }, status: :ok
    else
      render json: data: {
        status: "error"
      }, status: :ok
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_building
      @building = Building.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def building_params
      params.require(:building).permit(:number, :name, :nickname, :year, :lat, :lng, :history, :image,:close_to)
    end
end
