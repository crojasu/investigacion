class PagesController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :generales
  helper_method :por_agnos
  helper_method :personas
  helper_method :personas2
  helper_method :tecnico
  helper_method :tecnicogeneral
  helper_method :tecnicorol
  helper_method :suma
  helper_method :sum
  helper_method :salas
  helper_method :graficosgenerales
  before_action :peliculas
   # before_action :roles
   # before_action :roles_agnos

def home
end

def por_agnos(ano, gen)
   @agno =[]
  if gen == "mujer"
    @agno =[]
      @mujer.each do |pel|
       if pel.agno == ano.to_i
         @agno << pel
       end
     end
     return @agno.count
    elsif gen == "hombre"
      @agno =[]
      @hombre.each do |pel|
       if pel.agno == ano.to_i
         @agno << pel
       end
     end
      return @agno.count
    elsif gen == "otro"
      @agno =[]
      @otro.each do |pel|
       if pel.agno == ano.to_i
         @agno << pel
       end
     end
      return @agno.count
    end
end

def personas(ano, gen)
  @e= Rol.where(sexo: gen , ano: ano )
  return @e.count
end

def personas2(gen)
  @e= Personaje.where(genero: gen)
  return @e.count
end

def sum(ano, tipo, gen)
  @e= Fondo.where(sexo: gen , agno: ano , tipo: tipo)
  return @e.count
end

def suma(ano, tipo, gen)
  @fondos = Fondo.where(agno: ano, tipo: tipo, sexo: gen)
  if @fondos.count == 0
    return 0
  else
    return ((((@fondos.map(&:monto)).sum(&:to_f))/1000000).to_f).round(2)
  end
end

def salas(ano,item, gen, rol)
  @agno2 =[]
  @peliculaspor=[]
  por_agnos(ano, gen)
    if @agno.count == 0
      return 0
    else
        @agno.each do |pel|
          if pel.publico != nil
            @agno2 << pel
          end
        end
        if @agno2.count == 0
          return 0
        else
          if item == "Salas"
            return (((@agno.map(&:salas).sum(&:to_i))/@agno2.count)).round(1)
          elsif item == "Público"
            @peliculaspor << @agno2
            return (((@agno.map(&:publico).sum(&:to_i))/@agno2.count)).round(1)
          elsif item == "Copias"
            return (((@agno.map(&:copias).sum(&:to_i))/@agno2.count)).round(1)
          end
        end
    end
end

def tecnico(ano, rol, gen)
  @e= Rol.where(sexo: gen , ano: ano , name: rol)
  return @e.count
end

def tecnicogeneral(rol, gen)
  @e= Rol.where(sexo: gen , name: rol)
  return @e.count
end

def tecnicorol(rol)
  @e= Rol.where(name: rol)
  return @e.count
end


  private

def peliculas
    @hombre = []
    @mujer =[]
    @otro =[]
    @fhombre =[]
    @fmujer =[]
    @fotro =[]
    @hombre = Pelicula.where("sexos @> hstore(:key, :value)", key: "0", value: "Hombre") + Pelicula.where("sexos @> hstore(:key, :value)", key: "1", value: "Hombre")
    @mujer = Pelicula.where("sexos @> hstore(:key, :value)", key: "0", value: "Mujer") + Pelicula.where("sexos @> hstore(:key, :value)", key: "1", value: "Mujer")
    @otro =  Pelicula.where("sexos @> hstore(:key, :value)", key: "0", value: "Otro") + Pelicula.where("sexos @> hstore(:key, :value)", key: "1", value: "Otro")
    # @hombre.each do |pel|
    #   (pel.fondos).each do |fx|
    #     fx.sexo = "Hombre"
    #     fx.save
    #      @fhombre << fx
    #   end
    # end
    #  @mujer.each do |pel|
    #   (pel.fondos).each do |fx|
    #     fx.sexo = "Mujer"
    #     fx.save
    #     @fmujer << fx
    #   end
    # end
    # @otro.each do |pel|
    #   (pel.fondos).each do |fx|
    #     fx.sexo = "Otro"
    #     fx.save
    #      @fotro << fx
    #   end
    # end
  end

   # def roles
   #  @rol = Rol.all
   #  @rol.each do |rol|
   #    if rol.personaje.genero == "Hombre"
   #      rol.sexo = "Hombre"
   #      rol.save
   #    elsif rol.personaje.genero == "Mujer"
   #      rol.sexo = "Mujer"
   #      rol.save
   #    elsif rol.personaje.genero == "Otro"
   #      rol.sexo = "Otro"
   #      rol.save
   #    end
   #  end
   # end

   # def roles_agnos
   #   @rol = Rol.all
   #  @rol.each do |rol|
   #    rol.ano = rol.pelicula.agno
   #      rol.save
   #    end
   # end

def generales
  @rols= [ "Dirección", "Guión", "Producción Asociada", "Producción Ejecutiva", "Producción","Dirección Fotografía", "Arte", "Asistente Dirección", "Jefatura de Producción",  "Montaje", "Música", "Sonido", "Maquillaje", "Vestuario", "Elenco"]
  @anos=[ "2005", "2006", "2007", "2008", "2009", "2010", "2011", "2012", "2013", "2014", "2015"]
  @peliculas =Pelicula.all
  @corfo = Fondo.where(tipo: "corfo")
  @fondart = Fondo.where(tipo: "fondart")
  @hombre = Pelicula.where("sexos @> hstore(:key, :value)", key: "0", value: "Hombre") + Pelicula.where("sexos @> hstore(:key, :value)", key: "1", value: "Hombre")
  @mujer = Pelicula.where("sexos @> hstore(:key, :value)", key: "0", value: "Mujer") + Pelicula.where("sexos @> hstore(:key, :value)", key: "1", value: "Mujer")
  @otro =  Pelicula.where("sexos @> hstore(:key, :value)", key: "0", value: "Otro") + Pelicula.where("sexos @> hstore(:key, :value)", key: "1", value: "Otro")
end
end


