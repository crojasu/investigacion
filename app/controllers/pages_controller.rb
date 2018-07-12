class PagesController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :generales
  helper_method :peliculas
  helper_method :personas
  helper_method :tecnico
  helper_method :suma
  helper_method :sum
  helper_method :salas
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
      return @mujer.count
    elsif gen == "hombre"
      return @hombre.count
    elsif gen == "otro"
      return @otro.count
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
      return @mujer.count
    elsif gen  == "hombre"
      return @hombre.count
    elsif gen  == "otro"
      return @otro.count
    end
  end

  # def tablas
  #   @todorols= [ "Direccion", "Arte", "Asistente Direccion", "Direccion Fotografia", "Efectos Especiales", "Guion", "Jefatura de Producción", "Maquillaje", "Montaje", "Musica", "Produccion", "Produccion Asociada", "Produccion Ejecutiva", "Sonido", "Voz en Off", "Elenco", "Animacion", "Decoracion", "Vestuario"]
  # end

  def graficos
  end

def sum(ano, tipo, gen)
  @fondos = Fondo.where(agno: ano, tipo: tipo)
    @hombre =[]
    @mujer = []
    @otro =[]
  @fondos.each do |f|
  @rols = (Pelicula.find(f.pelicula_id)).rols
   @rold= @rols.where(name: "Direccion")
   @rold.each do |rol|
       if  rol.personaje.genero == "Hombre"
          @hombre << f
        elsif  rol.personaje.genero == "Mujer"
          @mujer << f
        elsif  rol.personaje.genero == "Otro"
          @otro <<  f
        end
      end
    end
    if gen == "mujer"
      return @mujer.count
    elsif gen == "hombre"
      return @hombre.count
    elsif gen == "otro"
      return @otro.count
    end
end

def suma(ano, tipo, gen)
  @fondos = Fondo.where(agno: ano, tipo: tipo)
    @hombre =[]
    @mujer = []
    @otro =[]
  @fondos.each do |f|
  @rols = (Pelicula.find(f.pelicula_id)).rols
   @rold= @rols.where(name: "Direccion")
   @rold.each do |rol|
       if  rol.personaje.genero == "Hombre"
          @hombre << f
        elsif  rol.personaje.genero == "Mujer"
          @mujer << f
        elsif  rol.personaje.genero == "Otro"
          @otro <<  f
        end
      end
    end
    if gen == "mujer"
      return (@mujer.map(&:monto).sum(&:to_i))/650
    elsif gen == "hombre"
      return (@hombre.map(&:monto).sum(&:to_i))/650
    elsif gen == "otro"
      return (@otro.map(&:monto).sum(&:to_i))/650
    end
end

def salas(ano, item, gen, rol)
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
  if item == "salas"
    if gen == "mujer"
      return @mujer.map(&:salas).sum(&:to_i)
    elsif gen == "hombre"
      return @hombre.map(&:salas).sum(&:to_i)
    elsif gen == "otro"
      return @otro.map(&:salas).sum(&:to_i)
    end
  elsif item == "publico"
       if gen == "mujer"
      return @mujer.map(&:publico).sum(&:to_i)
    elsif gen == "hombre"
      return @hombre.map(&:publico).sum(&:to_i)
    elsif gen == "otro"
      return @otro.map(&:publico).sum(&:to_i)
    end
  elsif item == "copias"
       if gen == "mujer"
      return @mujer.map(&:copias).sum(&:to_i)
    elsif gen == "hombre"
      return @hombre.map(&:copias).sum(&:to_i)
    elsif gen == "otro"
      return @otro.map(&:copias).sum(&:to_i)
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
  @rols= [ "Dirección", "Arte", "Asistente Dirección", "Dirección Fotografía", "Efectos Especiales", "Guión", "Jefatura de Producción", "Maquillaje", "Montaje", "Música", "Producción", "Producción Asociada", "Producción Ejecutiva", "Sonido", "Voz en Off", "Elenco", "Animación", "Decoración", "Vestuario"]
  @anos=[ "2005", "2006", "2007", "2008", "2009", "2010", "2011", "2012", "2013", "2014", "2015"]
  @peliculas =Pelicula.all
  @corfo = Fondo.where(tipo: "orfo")
  @fondart = Fondo.where(tipo: "fondart")
  end
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




