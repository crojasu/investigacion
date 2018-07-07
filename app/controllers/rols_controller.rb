class RolsController < ApplicationController
 helper_method :methrols
 before_action :generales
  def index

  end

  def show
   @rols = Rol.where(name: rol)
  end

 def methrols(rol)
   @rol = Rol.where(name: rol)
   return @rol
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
