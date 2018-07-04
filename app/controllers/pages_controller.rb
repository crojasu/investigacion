class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
    @mujer = []
    @hombre = []
    @nosesabe = []
    @rols = Rol.where(name: "Direccion")
    @rols.each do |rol|
      if rol.personaje.genero == true
      @mujer << rol
      elsif rol.personaje.genero == false
        @hombre << rol
      else
      @nosesabe << rol
    # end
    # 2005=Pelicula.where(agno: 2005)
    # @2005mujer = Rol.where(pelicula_id: 2005)
    # 2006=Pelicula.where(agno: 2006)
    # 2007=Pelicula.where(agno: 2007)
    # 2008=Pelicula.where(agno: 2008)
    # 2009=Pelicula.where(agno: 2009)
    # 2010=Pelicula.where(agno: 2010)
    # 2011=Pelicula.where(agno: 2011)
    # 2012=Pelicula.where(agno: 2012)
    # 2013=Pelicula.where(agno: 2013)
    # 2014=Pelicula.where(agno: 2014)
    # 2015=Pelicula.where(agno: 2015)
    # 2016=Pelicula.where(agno: 2016)
     end
   end
  end
end
