require 'csv'
require 'json'
require 'open-uri'
require 'i18n'

class RolsController < ApplicationController
skip_before_action :authenticate_user!
 helper_method :import
 before_action :generales

  def index
    @rols= Rol.all
  end

  def todos
  @personajes= Personaje.all
  @personajes.map do |rol|
    if rol.name== nil
      rol.name = "ninguno"
   end
 end
  end

def import
  parse_csv_rol(params[:file]).each_with_index do |row, index|
    cinechile = Pelicula.find_by(idcinechile: row[:pelicula_id])
    @roldepeliculas = Rol.where(pelicula_id: cinechile.id)
    @rol= @roldepeliculas.where(name: params[:commit])
    @persona = Personaje.find_by(name: row[:name])
    if @rol.nil?
      pe3 = Personaje.create(name: row[:name])
      da3 = Rol.create(name: params[:commit])
      da3.pelicula = cinechile
      da3.personaje = pe3
      da3.save
    elsif @persona && @rol.any? {|rol| rol.personaje_id = @persona.id}
        puts "nada"
    elsif @persona
        da = Rol.create(name: params[:commit])
        da.pelicula = cinechile
        da.personaje = @persona
        da.save
      elsif @rol
        @rol.each do |rol|
          if rol.personaje.genero == "Otro"
            actualizar = rol.personaje
            actualizar.update(name:row[:name], genero: "Hombre")
          end
        end
      else
        pe3 = Personaje.create(name: row[:name])
        da3 = Rol.create(name: params[:commit])
        da3.pelicula = cinechile
        da3.personaje = pe3
        da3.save
        end
  end
redirect_to rols_path
end

  def show
   @rols = Rol.where(name: params[:id])
  end

  private

  def generales
    @peliculas = Pelicula.all
    @rols = Rol.all
    @todorol= [ "Direccion", "Arte", "Asistente Direccion", "Direccion Fotografia", "Efectos Especiales", "Guion", "Jefatura de Produccion", "Maquillaje", "Montaje", "Musica", "Produccion", "Produccion Asociada", "Produccion Ejecutiva", "Sonido", "Voz en Off", "Elenco", "Animacion", "Decoracion", "Vestuario"]
  end

 def parse_csv_rol(file)
    csv_options = { col_sep: ',', headers: :first_row }
    rol = []
    CSV.foreach(file.path, csv_options) do |row|
      nombre = I18n.transliterate(row["nombre_personaje"]).upcase
      rol << {name: nombre, pelicula_id: row["pelicula_id"]}
  end
    rol
  end

  def allowed_params
    params.require(:rol).permit(:name, :pelicula_id)
  end
end
