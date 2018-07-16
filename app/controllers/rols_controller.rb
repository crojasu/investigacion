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
    @persona = Personaje.find_by(name: row[:name])
    if @persona == nil
    @persona = Personaje.create(name: row[:name])
  end
   unless Rol.find_by(name:params[:commit], personaje_id: @persona.id, pelicula_id: cinechile.id)
        da3 = Rol.create(name: params[:commit])
        da3.pelicula = cinechile
        da3.personaje = @persona
        da3.save
    end
  end
redirect_to rols_path
Rol.dedupe
end

  def show
   @rols = Rol.where(name: params[:id])
   @personaje=[]
   @rols.each do |rol|
    @personaje<< rol.personaje
  end
  @personajes = @personaje.uniq!
  end

  private

  def generales
    @peliculas = Pelicula.all
    @rols = Rol.all
    @todorol= [ "Dirección", "Guión", "Producción Asociada", "Producción Ejecutiva", "Producción", "Casa Productora","Dirección Fotografía", "Arte", "Asistente Dirección", "Jefatura de Producción",  "Montaje", "Música", "Sonido", "Maquillaje", "Decoración", "Vestuario", "Efectos Especiales",  "Animación", "Voz en Off", "Elenco"]
  end

 def parse_csv_rol(file)
    csv_options = { col_sep: ',', headers: :first_row }
    roli = []
    CSV.foreach(file.path, csv_options) do |row|
      nombre = I18n.transliterate(row["nombre_personaje"]).upcase
      roli << {name: nombre, pelicula_id: row["pelicula_id"]}
  end
    roli
  end

  def allowed_params
    params.require(:rol).permit(:name, :pelicula_id, :personaje_id)
  end
end
