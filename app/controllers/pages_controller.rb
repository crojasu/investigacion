class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]
  helper_method :mujer
  helper_method :hombre
  helper_method :fondosyhombre
  helper_method :fondosymujer
  helper_method :fondoshombrepe
  helper_method :fondosmujerpe
  helper_method :peliculasmujer
  helper_method :peliculashombre
  helper_method :fondoshombre
  helper_method :fondosmujer
  helper_method :corfomujer
  helper_method :corfohombre

  def home
  @todorol= [ "Direccion", "Arte", "Asistente Direccion", "Direccion Fotografia", "Efectos Especiales", "Guion", "Jefatura de Produccion", "Maquillaje", "Montaje", "Musica", "Produccion", "Produccion Asociada", "Produccion Ejecutiva", "Sonido", "Voz en Off", "Elenco", "Animacion", "Decoracion", "Vestuario"]
  @anos=[ "2005", "2006", "2007", "2008", "2009", "2010", "2011", "2012", "2013", "2014", "2015"]
  end

  def peliculashombre(ano, rol, item)
    @peliculas = Pelicula.where(agno: ano)
    @hombre = []
    @peliculas.each do |peli|
    @rols = Rol.where(pelicula_id: peli.id, name: rol)
      @rols.each do |rol|
    if rol.personaje.genero == "Hombre"
    @hombre << peli
      end
    end
    end
    if item == nil
    return @hombre
    else
      @hombre.each do |pel|
        @fondo = Fondo.where(tipo: item, pelicula_id: pel.id)
      end
          raise
    return @fondo
  end
  end

 def peliculasmujer(ano, rol, item)
    @peliculas = Pelicula.where(agno: ano)
    @mujer = []
    @peliculas.each do |peli|
    @rols = Rol.where(pelicula_id: peli.id, name:rol)
      @rols.each do |rol|
        if rol.personaje.genero == "Mujer"
        @mujer << peli
        end
    end
    end
    return @mujer
  end

def fondosmujer(ano, item)
  @mujer=[]
  @peliculas = Pelicula.where(agno: ano)
   @peliculas.each do |peli|
    @fondos = Fondo.where(pelicula_id: peli.id, tipo:item)
    @fondos.each do |fondo|
      @rol =Rol.where(name: "Direccion", pelicula_id: peli)
      @rol.each do |rol|
        if  rol.personaje.genero == "mujer"
        @mujer << fondo
        end
      end
    end
  end
end

def fondoshombre(ano, item)
  @hombre=[]
  @peliculas = Pelicula.where(agno: ano)
   @peliculas.each do |peli|
    @fondos = Fondo.where(pelicula_id: peli.id, tipo:item)
    @fondos.each do |fondo|
      @rol =Rol.where(name: "Direccion", pelicula_id: peli)
      @rol.each do |rol|
        if  rol.personaje.genero == "hombre"
        @hombre << fondo
        end
      end
    end
  end
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

def fondosyhombre(ano)
  @peliculas = Pelicula.where(agno: ano)
  @hombre = []
  @peliculas.each do |peli|
   @rols= peli.rols
   @rols.each do |rol|
    if rol.personaje.genero == "Hombre"
    @hombre << rol.personaje
      end
    end
    end
    return @hombre.count
  end


def fondosymujer(ano)
  @peliculas = Pelicula.where(agno: ano)
  @mujer = []
  @peliculas.each do |peli|
   @rols= peli.rols
   @rols.each do |rol|
    if rol.personaje.genero == "Mujer"
    @mujer << rol.personaje
      end
    end
    end
    return @mujer.count
  end

  def tablas
    @todorols= [ "Direccion", "Arte", "Asistente Direccion", "Direccion Fotografia", "Efectos Especiales", "Guion", "Jefatura de Produccion", "Maquillaje", "Montaje", "Musica", "Produccion", "Produccion Asociada", "Produccion Ejecutiva", "Sonido", "Direccion", "Voz en Off", "Elenco", "Casa Productora", "Animacion", "Decoracion", "Vestuario"]
  end

  def graficos
    @rols= [ "Direccion", "Arte", "Asistente Direccion", "Direccion Fotografia", "Efectos Especiales", "Guion", "Jefatura de Produccion", "Maquillaje", "Montaje", "Musica", "Produccion", "Produccion Asociada", "Produccion Ejecutiva", "Sonido", "Direccion", "Voz en Off", "Elenco", "Casa Productora", "Animacion", "Decoracion", "Vestuario"]
    @anos=[ "2005", "2006", "2007", "2008", "2009", "2010", "2011", "2012", "2013", "2014", "2015"]
    @peliculas =Pelicula.all
    @corfo = Fondo.where(tipo: "corfo")
    @fondart = Fondo.where(tipo: "fondart")
  end

  def corfohombre(ano, item)
    @peliculas = Pelicula.where(agno: ano)
    @hombre = []
    @peliculas.each do |peli|
      @rol =Rol.where(name: "Direccion", pelicula_id: peli)
      @rol.each do |rol|
       if  rol.personaje.genero == "Hombre"
          @fondo= Fondo.where(tipo: item, pelicula_id: peli)
          if @fondo != []
        @hombre << Fondo.find_by(tipo: item, pelicula_id: peli)
      end
        end
      end
    end
    return @hombre
  end

    def corfomujer(ano, item)
    @peliculas = Pelicula.where(agno: ano)
      @mujer = []
    @peliculas.each do |peli|
      @rol =Rol.where(name: "Direccion", pelicula_id: peli)
      @rol.each do |rol|
        if  rol.personaje.genero == "Mujer"
          @fondo= Fondo.where(tipo: item, pelicula_id: peli)
          if @fondo != []
        @mujer << Fondo.find_by(tipo: item, pelicula_id: peli)
      end
        end
      end
    end
    return @mujer
  end
end
