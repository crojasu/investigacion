require 'csv'
require 'json'
require 'open-uri'
require 'i18n'

class PeliculasController < ApplicationController
  before_action :generales

  def index
    @peliculas = Pelicula.all
     @rols = Rol.all
     @todorol= [ "Direccion", "Arte", "Asistente de Direccion", "Direccion de Fotografia", "Efectos", "Guion", "Jefatura de Produccion", "Maquillaje","Montaje", "Musica", "Produccion", "Produccion Asociada", "Produccion Ejecutiva", "Realizacion", "Sonido", "Voz en off", "Elenco", "Casa Productora"]
    @todorol.each do |rol|
      @rol = Rol.where(name: rol)
    end
  end

  def show
    @personas =[]
    @mujer=[]
    @hombre =[]
    @pelicula = Pelicula.find(params[:id])
    @fondo = Fondo.where(pelicula_id: @pelicula.id)
    @fondos_corfo = Fondo.where(pelicula_id: @pelicula.id, tipo: "corfo")
    @fondos_fondart = Fondo.where(pelicula_id: @pelicula.id, tipo: "fondart")
    @rols = Rol.where(pelicula_id: @pelicula.id)
    @directors = Rol.where(pelicula_id: @pelicula.id, name: "Direccion")
    @rols.each do |rol|
      if rol.personaje.genero == true
      @mujer << rol
      elsif rol.personaje.genero == false
      @hombre << rol
      end
    end
  end

  def new
    @pelicula = Pelicula.new
  end

  def create
    @pelicula = Pelicula.new(pelicula_params)
    if @pelicula.save
      redirect_to pelicula_path(@pelicula)
    else
      render :new
    end
  end

  def destroy
    @pelicula = Pelicula.find(params[:id])
    @pelicula.destroy
    redirect_to peliculas_path
  end

  def edit
    @pelicula = Pelicula.find(params[:id])
  end

  def matchs(rol)
    t = Pelicula.find(params[:id])
    @roldepeliculas = Rol.where(pelicula_id: t.id)
    value2 = t.imbd
    value = JSON.parse value2.gsub('=>', ':')
    if value[rol] != "N/A" && value[rol] != nil
        value[rol].split(",").each do |dir|
        dire = I18n.transliterate(dir).upcase
        @persona = Personaje.find_by(name: dire)
        if rol == "Director"
          @uni = "Direccion"
          elsif rol == "Writer"
          @uni = "Guion"
          elsif rol == "Actors"
          @uni = "Elenco"
          elsif rol == "Production"
          @uni = "Casa Productora"
        end
        @rol= @roldepeliculas.where(name: @uni)
          if @persona
            @borrar = @rol.select {|rol| rol.personaje_id = @persona.id}
              @borrar.each do |b|
                b.destroy
              end
            end
          end
        end
  end

  def update
    t = Pelicula.find(params[:id])
    @r = t.imbd
    @f= JSON.parse @r.gsub('=>', ':')
    imbd = @f["imdbID"]
    url = "http://www.omdbapi.com/?i=#{imbd}&apikey=e91b7024"
    user_serialized = open(url).read
    value = JSON.parse(user_serialized)
#Borramos los que existen
    t.imbd = value
    t.save
    @roldepeliculas = Rol.where(pelicula_id: t.id)
    if value["Response"]== "True"
    self.matchs("Director")
    self.matchs("Writer")
    self.matchs("Actors")
    self.matchs("Production")
    end
#agregamos los nuevos
    imbd2 = params[:pelicula][:imbd]
    url2 = "http://www.omdbapi.com/?i=#{imbd2}&apikey=e91b7024"
    user_serialized2 = open(url2).read
    value = JSON.parse(user_serialized2)
    t.imbd = value
    t.save
  @roldepeliculas = Rol.where(pelicula_id: t.id)
    if value["Response"]== "True"
    self.add("Director")
    self.add("Writer")
    self.add("Actors")
    self.add("Production")
    end
        redirect_to peliculas_path
  end

  def add(rol)
    t = Pelicula.find(params[:id])
    @roldepeliculas = Rol.where(pelicula_id: t.id)
    value2 = t.imbd
    value = JSON.parse value2.gsub('=>', ':')
      if rol == "Director"
          @uni = "Direccion"
          elsif rol == "Writer"
          @uni = "Guion"
          elsif rol == "Actors"
          @uni = "Elenco"
          elsif rol == "Production"
          @uni = "Casa Productora"
        end
    if value[rol] != "N/A"
      value[rol].split(",").each do |dir|
      dire = I18n.transliterate(dir).upcase
      @persona = Personaje.find_by(name: dire)
      @rol= @roldepeliculas.where(name: @uni)
        if @persona && @rol.any? {|rol| rol.personaje_id = @persona.id}
          elsif @persona
            da = Rol.create(name: @uni)
            da.pelicula = t
            da.personaje = @persona
            da.save
          else
          pe = Personaje.create(name: dire)
          da = Rol.create(name: @uni)
          da.pelicula = t
          da.personaje = pe
          da.save
        end
        end
      end
    end

  private

  def generales
     @peliculas = Pelicula.all
     @rols = Rol.all
     @todorol= [ "Direccion", "Arte", "Asistente de Direccion", "Direccion de Fotografia", "Efectos", "Guion", "Jefatura de Produccion", "Maquillaje","Montaje", "Musica", "Produccion", "Produccion Asociada", "Produccion Ejecutiva", "Realizacion", "Sonido", "Voz en off", "Elenco", "Casa Productora"]
  end

  def pelicula_params
    params.require(:pelicula).permit(:agno, :titulo, :responsable, :monto, :institucion, :imbd, :idcinechile, :contacto)
  end
end
