require 'csv'
require 'json'
require 'open-uri'
require 'i18n'

class RolsController < ApplicationController
 helper_method :import
 before_action :generales

  def index
    @rols= Rol.all
  end

  def show
   @rols = Rol.where(name: params[:id])
  end

  def import
   Rol.import(params[:file])
   redirect_to rols_path , notice: "importados"
  end

  private

  def generales
     @peliculas = Pelicula.all
     @rols = Rol.all
     @todorol= [ "Direccion", "Arte", "Asistente de Direccion", "Direccion de Fotografia", "Efectos", "Guion", "Jefatura de Produccion", "Maquillaje", "Montaje", "Musica", "Produccion", "Produccion Asociada", "Produccion Ejecutiva", "Realizacion", "Sonido","Voz en off", "Elenco", "Casa Productora"]
  end

  def allowed_params
    params.require(:rol).permit(:name)
  end
end
