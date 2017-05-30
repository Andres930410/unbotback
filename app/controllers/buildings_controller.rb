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
      when "information::nickname_un"
        information_value = "nickname"
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
      history = ["La historia del edificio es: ", "Esta es la informacion que tenemos sobre el edificio: ","Esto puede ser de interes: ","Sabias que: ","Memoriza esto: ","Esto es interesante aprender"]
      age = ["La edad del edificio es:","Los años que tienen este edificio es:","por el momento el edificio tiene:","Los años pasan, pero por ahora este edificio tiene:","Es un poco viejo este edificio tiene:"]
      number = ["El numbero es:","Tal vez lo puedas recordar como:","El numero del edificio es:","Aprendete este numero te sera muy util:","Son solo 3 numeros recuerdalo como:"]
      year = ["El año de apertura edificio es:","El edificio fue construido en el año:","Empezo a funcionar en:","Inicio en:","Tiene mucha historia, imaginate que empezo en:"]
      nickname = ["el apodo del edifico es:","tambie lo puede llamar:","llamalo de esta manera:","intente de esta forma:"]
      name = ["el nombre del edficio es:","intenta llamandolo:","que tal de esta forma:"]
      case information
      when "age"
        if @value.year
          message = "#{age.sample} #{Date.today.year - @value.year}"
        else
          message = "No tenemos informacion acerca de la edad del edificio"
        end
      when "name"
        message = "#{name.sample} #{@value.name}"
      when "nickname"
        if @value.nickname
          message = "#{nickname.sample} #{@value.nickname}"
        else
          message = "Este edificio no tiene apodo"
        end

      when "history"
        if @value.history
          message = "#{history.sample}\n#{@value.history}"
        else
          message = "No tenemos informacion relacionado con la historia del edificio"
        end
      when "number"
        message = "#{number.sample} #{@value.number}"
      when "year"
        if @value.year
          message = "#{year.sample} #{@value.year}"
        else
          message = "No tenemos informacion acerca del año de fundacion del edificio"
        end
      when "close"
        message = "Los edificios cercanos son: #{@value.close_to}"
      when "julio"
        julio_zorra = ["Busca en tu corazon","Pregunta mas tarde",
        "Julio zorra es alfa y omega. El todo y la nada, El proporciona toda la energía vital que alimenta a los estudiantes durante su carrera universitaria.",
        "Según la tradición popular Julio Zorra es un ser etéreo de naturaleza desconocida tan básico como las fuerzas primigenias del universo. Domina todas las áreas del conocimiento, se graduó de todas las carreras de la UNal con P.A.P.A en 5.0. Le dictó clase a Pecha, Alfonso Cano, Gabo, Jorge Eliecer Gaitán, Sarmiento Angulo, El del billete de 20. Le enseñó los chistes a Jaime Garzón. Fue la Primera vez de Esperanza Gómez.",
        "JulioZorra es superior a todas las posiciones políticas, credos, religiones, doctrinas, filosofías existentes. JulioZorra ha estado presente en todos los eventos significativos del país. Una de las tantas historias sobre él cuenta que JulioZorra fue el primero en hacer tropel en la UNAl, para ello creo el consejo superior de capuchos que salvan a los estudiantes de parciales en los momento más cruciales.",
        "Invocar a JulioZorra o querer hacerlo es jugar con la estructura fundamental del universo. No se recomienda hacerlo. (Sacado del twitter de BúhoSerio, Gran Sacerdote del JulioZorrismo).",
        "Básicamente es una imagen creada en torno a un individuo que hace más de un millar de eones (un par de años) hizo algo trascendente en el grupo y de ahí surgió el meme, letanía y rezo #JulioZorra. Pocos recuerdan las acciones que lo llevaron a convertirse en una deidad tan famosa y memeticamente poderosa, cosa que realmente no importa. Lo único pertinente a decir con este respecto es que NO se debe preguntar NUNCA por su origen. De llegar a formularse tal incógnita, se cernirá sobre el individuo que la pronuncie un mar de tortura y sufrimiento interminable de colosales dimensiones (Bullying a más no poder).",
        "La misión de todo siervo fiel, seguidor de la palabra de #JulioZorra, es ayudar, precisamente, a forjar ese martirio cuando alguien lo invoque sobre sí. Ese es el deber de todo unaleño peregrino de las bastas enseñanzas de la más altísima deidad jamás conocida."]
        message = julio_zorra.sample
      else
        if @value.history
          message = "#{history.sample}\n#{@value.history}"
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
