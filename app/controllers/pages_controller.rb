class PagesController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :generales
  helper_method :peliculas
  helper_method :fondo
  helper_method :personas
  helper_method :tecnico

  def home
  end

  def peliculas(ano, rol, gen)
    @peliculas = Pelicula.where(agno: ano)
    @hombre = []
    @mujer =[]
    @otro =[]
    @peliculas.each do |peli|
    @rols = Rol.where(pelicula_id: peli.id, name: rol)
      @rols.each do |rol|
        if rol.personaje.genero == "Hombre"
          @hombre << peli
        elsif  rol.personaje.genero == "Mujer"
          @mujer << peli
        elsif  rol.personaje.genero == "Otro"
          @otro <<  peli
        end
      end
    end
    if gen == "mujer"
      return @mujer
    elsif gen == "hombre"
      return @hombre
    elsif gen == "otro"
      return @otro
    end
  end

def personas(ano, gen)
  @peliculas = Pelicula.where(agno: ano)
  @hombre = []
  @mujer = []
  @otro = []
  @peliculas.each do |peli|
   @rols= peli.rols
   @rols.each do |rol|
      if rol.personaje.genero == "Hombre"
        @hombre << rol.personaje
      elsif rol.personaje.genero == "Mujer"
        @mujer << rol.personaje
      elsif rol.personaje.genero == "Otro"
        @otro << rol.personaje
      end
    end
  end
   if gen == "mujer"
      return @mujer
    elsif gen  == "hombre"
      return @hombre
    elsif gen  == "otro"
      return @otro
    end
  end

  # def tablas
  #   @todorols= [ "Direccion", "Arte", "Asistente Direccion", "Direccion Fotografia", "Efectos Especiales", "Guion", "Jefatura de Produccion", "Maquillaje", "Montaje", "Musica", "Produccion", "Produccion Asociada", "Produccion Ejecutiva", "Sonido", "Voz en Off", "Elenco", "Animacion", "Decoracion", "Vestuario"]
  # end

  def graficos
  end

  def fondo(ano, item, gen)
    @peliculas = Pelicula.where(agno: ano)
    @hombre = []
     @mujer = []
     @otro = []
    @peliculas.each do |peli|
      @rol =Rol.where(name: "Direccion", pelicula_id: peli.id)
      @rol.each do |rol|
       if  rol.personaje.genero == "Hombre"
          @hombre << Fondo.where(tipo: item, pelicula_id: peli.id)
        elsif  rol.personaje.genero == "Mujer"
          @mujer << Fondo.where(tipo: item, pelicula_id: peli.id)
        elsif  rol.personaje.genero == "Otro"
          @otro <<  Fondo.where(tipo: item, pelicula_id: peli, agno: ano)
        end
      end
    end
    if gen == "mujer"
      return @mujer
    elsif gen == "hombre"
      return @hombre
    elsif gen == "otro"
      return @otro
    end
  end
  end

  def tecnico(ano, rol, gen)
    @peliculas = Pelicula.where(agno: ano)
    @hombre = []
    @otro = []
    @mujer = []
    @peliculas.each do |peli|
    @rols = Rol.where(pelicula_id: peli.id, name: rol)
      @rols.each do |rol|
      if rol.personaje.genero == "Hombre"
          @hombre << rol
        elsif  rol.personaje.genero == "Mujer"
          @mujer << rol
        elsif  rol.personaje.genero == "Otro"
          @otro <<  rol
        end
      end
    end
    if gen == "mujer"
      return @mujer.count
    elsif gen == "hombre"
      return @hombre.count
       raise
    elsif gen == "otro"
      return @otro.count
    end
  end

  private

  def generales
  @rols= [ "Direccion", "Arte", "Asistente Direccion", "Direccion Fotografia", "Efectos Especiales", "Guion", "Jefatura de Produccion", "Maquillaje", "Montaje", "Musica", "Produccion", "Produccion Asociada", "Produccion Ejecutiva", "Sonido", "Voz en Off", "Elenco", "Animacion", "Decoracion", "Vestuario"]
  @anos=[ "2005", "2006", "2007", "2008", "2009", "2010", "2011", "2012", "2013", "2014", "2015"]
  @peliculas =Pelicula.all
  @corfo = Fondo.where(tipo: "corfo")
  @fondart = Fondo.where(tipo: "fondart")
  end

# def fondosymujer(ano)
#   @peliculas = Pelicula.where(agno: ano)
#   @mujer = []
#   @peliculas.each do |peli|
#    @rols= peli.rols
#    @rols.each do |rol|
#     if rol.personaje.genero == "Mujer"
#     @mujer << rol.personaje
#       end
#     end
#     end
#     return @mujer.count
#   end

# def fondosyotro(ano)
#   @peliculas = Pelicula.where(agno: ano)
#   @otro = []
#   @peliculas.each do |peli|
#    @rols= peli.rols
#    @rols.each do |rol|
#     if rol.personaje.genero == "Otro"
#     @otro << rol.personaje
#       end
#     end
#     end
#     return @otro.count
#   end

# def fondosmujer(ano, item)
#   @mujer=[]
#   @peliculas = Pelicula.where(agno: ano)
#    @peliculas.each do |peli|
#     @fondos = Fondo.where(pelicula_id: peli.id, tipo:item)
#     @fondos.each do |fondo|
#       @rol =Rol.where(name: "Direccion", pelicula_id: peli)
#       @rol.each do |rol|
#         if  rol.personaje.genero == "Mujer"
#         @mujer << fondo
#         end
#       end
#     end
#   end
# end

# def fondoshombre(ano, item)
#   @hombre=[]
#   @peliculas = Pelicula.where(agno: ano)
#    @peliculas.each do |peli|
#     @fondos = Fondo.where(pelicula_id: peli.id, tipo:item)
#     @fondos.each do |fondo|
#       @rol =Rol.where(name: "Direccion", pelicula_id: peli)
#       @rol.each do |rol|
#         if  rol.personaje.genero == "Hombre"
#         @hombre << fondo
#         end
#       end
#     end
#   end
# end


 # def mujer(ano, rol)
 #    @peliculas = Pelicula.where(agno: ano)
 #    @mujer = []
 #    @peliculas.each do |peli|
 #    @rols = Rol.where(pelicula_id: peli.id, name:rol)
 #      @rols.each do |rol|
 #    if rol.personaje.genero == "Mujer"
 #    @mujer << rol
 #    end
 #    end
 #  end
 #  return @mujer.count
 #  end




