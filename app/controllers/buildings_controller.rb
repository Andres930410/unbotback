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
    set_value(entities)
    if @value
      render json: {result: {
        status: "ok",
        data: @value
      }}, status: :ok
    else
      render json: {result: {
        status: "error"
      }}  , status: :ok
    end
  end

  def information
    entities = params["data"]
    information_value = ""
    is_correct = false
    entities.each do |e|
      if is_correct
        break
      end
      type = e["type"].gsub(/\s+/, "")
      case type
      when "information::age_un"
        information_value = "age"
        is_correct = true
      when "information::name_un"
        information_value = "name"
        is_correct = true
      when "information::history"
        information_value = "history"
        is_correct = true
      when "information::number_un"
        information_value = "number"
        is_correct = true
      when "information::year"
        information_value = "year"
        is_correct = true
      when "information::close_to"
        information_value = "close"
        is_correct = true
      when "julio_zorra"
        information_value = "julio"
        is_correct = true
      end
    end
    set_value(entities)
    if @value || information_value == "julio"
      render json: { result:{
          status: "ok",
          message: set_message(information_value)
        }
      }
    else
      render json: { result:{
          status: "error"
        }
      }
    end

  end

  def route
    entities = params["data"]
    places = []
    entities.each do |e|
      type = e["type"]
      case type
      when "building::nickname"
        v = Building.building_by_nickname(e["entity"])
      when "builtin.number"
        v = Building.building_by_number(e["resolution"]["value"])
      when "building::name"
        v = Building.building_by_name(e["entity"])
      end
      if v
        places<<v
      end
    end
    if places.count == 2
      render json: {
        result: {
          status: "ok",
          message: "https://www.google.com/maps/dir/?api=1&origin=#{places[0].lat},#{places[0].lng}&destination=#{places[1].lat},#{places[1].lng}&travelmode=walking"
        }
      }
    else
      render json: {
        result: {
          status: "error"
        }
      }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_value(entities)
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
    end

    def set_building
      @building = Building.find(params[:id])
    end

    def set_message(information)
      message = ""
      case information
      when "age"
        if @value.year
          message = "La edad del edificio es: #{Date.today.year - @value.year}"
        else
          message = "No tenemos informacion acerca de la edad del edificio"
        end
      when "name"
        message = "El nombre del edificio es: #{@value.name}"
      when "history"
        if @value.history
          message = "La historia del edificio es:\n#{@value.history}"
        else
          message = "No tenemos informacion relacionado con la historia del edificio"
        end
      when "number"
        message = "El numero del edificio es: #{@value.number}"
      when "year"
        if @value.year
          message = "La año de apertura edificio es: #{@value.year}"
        else
          message = "No tenemos informacion acerca del año de fundacion del edificio"
        end
      when "close"
        message = "Los edificios cercanos son: #{@value.close_to}"
      when "julio"
        message = "Busca en tu corazon"
      else
        if @value.history
          message = "La historia del edificio es:\n#{@value.history}"
        else
          message = "No tenemos informacion relacionado con la historia del edificio"
        end
      end
      message
    end

    # Only allow a trusted parameter "white list" through.
    def building_params
      params.require(:building).permit(:number, :name, :nickname, :year, :lat, :lng, :history, :image,:close_to)
    end
end
