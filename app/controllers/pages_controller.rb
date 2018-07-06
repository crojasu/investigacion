class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]
  helper_method :mujer
  helper_method :hombre

  def home
  @todorol= [ "Direccion", "Arte", "Asistente de Direccion", "Direccion de Fotografia", "Efectos", "Guion", "Jefatura de Produccion", "Maquillaje", "Montaje", "Musica", "Produccion", "Produccion Asociada", "Produccion Ejecutiva", "Realizacion", "Sonido", "Direccion", "Voz en off", "Elenco", "Casa Productora"]
    #  @anos=[ "2005", "2006", "2007", "2008", "2009", "2010", "2011", "2012", "2013", "2014", "2015"]
  end

 def mujer(ano, rol)
    @peliculas = Pelicula.where(agno: ano)
    @mujer = []
    @peliculas.each do |peli|
    @rols = Rol.where(pelicula_id: peli.id, name:rol)
      @rols.each do |rol|
    if rol.personaje.genero == true
    @mujer << rol
    end
    end
  end
  return @mujer.count
  end

  def hombre(ano, rol)
    @peliculas = Pelicula.where(agno: ano)
    @hombre = []
    @peliculas.each do |peli|
    @rols = Rol.where(pelicula_id: peli.id, name: rol)
      @rols.each do |rol|
    if rol.personaje.genero == false
    @hombre << rol
      end
    end
    end
    return @hombre.count
  end
end
