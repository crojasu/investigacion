class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]
  helper_method :mujer
  helper_method :hombre

  def home
  @todorol= [ "Direccion", "Arte", "Asistente Direccion", "Direccion Fotografia", "Efectos Especiales", "Guion", "Jefatura de Produccion", "Maquillaje", "Montaje", "Musica", "Produccion", "Produccion Asociada", "Produccion Ejecutiva", "Sonido", "Direccion", "Voz en Off", "Elenco", "Animacion", "Decoracion", "Vestuario"]
  @anos=[ "2005", "2006", "2007", "2008", "2009", "2010", "2011", "2012", "2013", "2014", "2015"]
  end

 def mujer(ano, rol)
    @peliculas = Pelicula.where(agno: ano)
    @mujer = []
    @peliculas.each do |peli|
    @rols = Rol.where(pelicula_id: peli.id, name:rol)
      @rols.each do |rol|
    if rol.personaje.genero == "Mujer"
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
    if rol.personaje.genero == "Hombre"
    @hombre << rol
      end
    end
    end
    return @hombre.count
  end

  def graficos
  @rols= [ "Direccion", "Arte", "Asistente Direccion", "Direccion Fotografia", "Efectos Especiales", "Guion", "Jefatura de Produccion", "Maquillaje", "Montaje", "Musica", "Produccion", "Produccion Asociada", "Produccion Ejecutiva", "Sonido", "Direccion", "Voz en Off", "Elenco", "Casa Productora", "Animacion", "Decoracion", "Vestuario"]
  @anos=[ "2005", "2006", "2007", "2008", "2009", "2010", "2011", "2012", "2013", "2014", "2015"]
  end
end
