require 'csv'
require 'json'
require 'open-uri'
require 'i18n'

class PeliculasController < ApplicationController
  skip_before_action :authenticate_user!
  helper_method :match_imbd

  def index
    @peliculas = Pelicula.all
    @rols = Rol.all
    @todorol= [ "Direccion", "Arte", "Asistente Direccion", "Direccion Fotografia", "Efectos Especiales", "Guion", "Jefatura de Produccion", "Maquillaje", "Montaje", "Musica", "Produccion", "Produccion Asociada", "Produccion Ejecutiva", "Sonido", "Voz en Off", "Elenco", "Animacion", "Decoracion", "Vestuario"]
    @todorol.each do |rol|
    rol = Rol.where(name: rol)
    end
  end

  def show
    @personas =[]
    @mujer=[]
    @hombre =[]
    @otro =[]
    @pelicula = Pelicula.find(params[:id])
    @fondo = Fondo.where(pelicula_id: @pelicula.id)
    @fondos_corfo = Fondo.where(pelicula_id: @pelicula.id, tipo: "corfo")
    @fondos_fondart = Fondo.where(pelicula_id: @pelicula.id, tipo: "fondart")
    @rols = Rol.where(pelicula_id: @pelicula.id)
    @directors = Rol.where(pelicula_id: @pelicula.id, name: "Direccion")
    @rols.each do |rol|
      if rol.personaje.genero == "Mujer"
      @mujer << rol
      elsif rol.personaje.genero == "Hombre"
      @hombre << rol
      elsif rol.personaje.genero == "Otro"
      @otro << rol
      end
    end
  end

  def import
    parse_csv_peliculas(params[:file]).each_with_index do |row, index|
      tit = I18n.transliterate(row[:titulo]).upcase
      busca= Pelicula.find_by(idcinechile: row[:idcinechile])
      if busca
        h = Rol.find_by(name: "Direccion" , pelicula_id: busca.id)
          if h.nil?
            r = Rol.create(name: "Direccion")
            p = Personaje.create(genero: "Otro" , name: "#{index+1}")
          r.pelicula = busca
          r.personaje = p
          r.save
         end
      else
        t = Pelicula.create(idcinechile: row[:idcinechile], agno: row[:agno], responsable: row[:responsable], tipo: row[:tipo], titulo: tit , salas: row[:salas], copias: row[:copias], publico: row[:publico])
        match_imbd(t)
        t.save
        h = Rol.find_by(name: "Direccion" , pelicula_id: t.id)
          if h.nil?
            r = Rol.create(name: "Direccion")
            p = Personaje.create(genero: "Otro" , name: "#{index+1}")
          r.pelicula = t
          r.personaje = p
          r.save
          end
        t.save
      end
    end
    parse_csv_fondos(params[:file])
    redirect_to peliculas_path
  end

  def match_imbd(t)
    sinficha =[]
    imbd  = I18n.transliterate(t.titulo).split.join('+')
    url = "http://www.omdbapi.com/?t=#{imbd}&apikey=e91b7024"
    user_serialized = open(url).read
    value = JSON.parse(user_serialized)
    t.imbd = value
    t.save
    if value["Response"]== "True"
    self.add("Director", t)
    self.add("Writer", t)
    self.add("Actors", t)
    self.add("Production", t)
    else
      sinficha << ("#{t.titulo}")
    end
  end

  def add(rol, t)
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
    if value[rol] != "N/A" && value[rol] != nil
      value[rol].split(",").each do |dir|
        dire = I18n.transliterate(dir).upcase
        @persona = Personaje.find_by(name: dire)
        @rol= @roldepeliculas.where(name: @uni, pelicula_id: t.id)
          if @persona && @rol.any? {|rol| rol.personaje_id = @persona.id}
            puts "hoola"
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
    self. match_imbd("Director")
    self.match_imbd("Writer")
    self.match_imbd("Actors")
    self.match_imbd("Production")
    end
#agregamos los nuevos
    imbd2 = params[:pelicula][:imbd]
    url2 = "http://www.omdbapi.com/?i=#{imbd2}&apikey=e91b7024"
    user_serialized2 = open(url2).read
    value = JSON.parse(user_serialized2)
    t.imbd = value
    t.save
    if value["Response"]== "True"
    self.add("Director")
    self.add("Writer")
    self.add("Actors")
    self.add("Production")
    end
        redirect_to peliculas_path
  end

private

  def parse_csv_peliculas(file)
    csv_options = { col_sep: ',', headers: :first_row }
    peliculas = []
    CSV.foreach(file.path, csv_options) do |row|
      tit = I18n.transliterate(row["titulo"]).upcase
      peliculas << {idcinechile: row["idcinechile"], agno: row["ano"], responsable: row["responsable"], tipo: row["tipo"], titulo: tit , salas: row["salas"], copias: row["copias"], publico: row["publico"]}
    end
    peliculas
  end

  def parse_csv_fondos(file)
    csv_options = { col_sep: ',', headers: :first_row }
    fondos = []
    CSV.foreach(file.path, csv_options) do |row|
      pelicula = Pelicula.find_by(idcinechile: row["idcinechile"])
      Fondo.create(monto: row["monto"], tipo: row["institucion"], pelicula_id: pelicula.id, agno: pelicula.agno)
    end
    fondos
  end

  def pelicula_params
    params.require(:pelicula).permit(:idcinechile, :agno, :responsable, :tipo, :titulo , :salas, :copias, :publico)
  end
end
