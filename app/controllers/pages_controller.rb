class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]
  def home
    # @n = 5
    # while @n < 16 do
    #   @ano = 2000 + @n
    #  peliculas = Pelicula.where(agno: @ano)
    #  peliculas.each do |peli, index|

    #     # =[]
    #   @rols = Rol.where(pelicula_id: peli.id , name: "Direccion")
    #   @rols.each do |rol|
    #     if rol.personaje.genero == true
    #     # index << rol
    #     @n=+1
    #     elsif rol.personaje.genero == false

    #        i=+1
    #     end
    #     end
    #   end
    end
  end
     # @peliculas = Pelicula.all
     # @directors = Rol.where(name: "Direccion")
     # @artes = Rol.where(name: "Arte")
     # @asistentdires = Rol.where(name: "Asistente de Direccion")
     # @direfotos = Rol.where(name: "Direccion de Fotografia")
     # @efectoss = Rol.where(name: "Efectos")
     # @guiones = Rol.where(name: "Guion")
     # @jefedeproduccion = Rol.where(name: "Jefatura de Produccion")
     # @maquillajes = Rol.where(name: "Maquillaje")
     # @montajistas = Rol.where(name: "Montaje")
     # @musicas = Rol.where(name: "Musica")
     # @productors = Rol.where(name: "Produccion")
     # @productorasociados = Rol.where(name: "Produccion Asociada")
     # @productorejecutivos = Rol.where(name: "Produccion Ejecutiva")
     # @realizacions = Rol.where(name: "Realizacion")
     # @sonidos = Rol.where(name: "Sonido")
     # @vestuarios = Rol.where(name: "Direccion")
     # @vozenoffs = Rol.where(name: "Voz en off")
     # @elenco = Rol.where(name: "Elenco")
     # @casaprod = Rol.where(name: "Casa Productora")
     # @agno5 = Pelicula.where(agno: 2005)
     # @agno6 = Pelicula.where(agno: 2006)
     # @agno7 = Pelicula.where(agno: 2007)
     # @agno8 = Pelicula.where(agno: 2008)
     # @agno9 = Pelicula.where(agno: 2009)
     # @agno10 = Pelicula.where(agno: 2010)
     # @agno11 = Pelicula.where(agno: 2011)
     # @agno12 = Pelicula.where(agno: 2012)
     # @agno13= Pelicula.where(agno: 2013)
     # @agno14= Pelicula.where(agno: 2014)
     # @agno15= Pelicula.where(agno: 2014)

