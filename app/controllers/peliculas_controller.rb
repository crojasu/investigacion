class PeliculasController < ApplicationController
  def index
     @peliculas = Pelicula.all
     @directors = Rol.where(name: "Direccion")
     @artes = Rol.where(name: "Arte")
     @asistentdires = Rol.where(name: "Asistente de Direccion")
     @direfotos = Rol.where(name: "Direccion de Fotografia")
     @efectoss = Rol.where(name: "Efectos")
     @guiones = Rol.where(name: "Guion")
     @jefedeproduccion = Rol.where(name: "Jefatura de Produccion")
     @maquillajes = Rol.where(name: "Maquillaje")
     @montajistas = Rol.where(name: "Montaje")
     @musicas = Rol.where(name: "Musica")
     @productors = Rol.where(name: "Produccion")
     @productorasociados = Rol.where(name: "Produccion Asociada")
     @productorejecutivos = Rol.where(name: "Produccion Ejecutiva")
     @realizacions = Rol.where(name: "Realizacion")
     @sonidos = Rol.where(name: "Sonido")
     @vestuarios = Rol.where(name: "Direccion")
     @vozenoffs = Rol.where(name: "Voz en off")
     @elenco = Rol.where(name: "Elenco")
     @casaprod = Rol.where(name: "Casa Productora")
     @agno5 = Pelicula.where(agno: 2005)
     @agno6 = Pelicula.where(agno: 2006)
     @agno7 = Pelicula.where(agno: 2007)
     @agno8 = Pelicula.where(agno: 2008)
     @agno9 = Pelicula.where(agno: 2009)
     @agno10 = Pelicula.where(agno: 2010)
     @agno11 = Pelicula.where(agno: 2011)
     @agno12 = Pelicula.where(agno: 2012)
     @agno13= Pelicula.where(agno: 2013)
     @agno14= Pelicula.where(agno: 2014)
     @agno15= Pelicula.where(agno: 2014)
     @todorol= [ "Direccion", "Arte", "Asistente de Direccion", "Direccion de Fotografia", "Efectos", "Guion", "Jefatura de Produccion", "Maquillaje"
     "Montaje", "Musica", "Produccion", "Produccion Asociada", "Produccion Ejecutiva", "Realizacion", "Sonido"
     "Direccion", "Voz en off", "Elenco", "Casa Productora"]
  end

  def show
    @personas =[]
    @pelicula = Pelicula.find(params[:id])
    @rols = Rol.where(pelicula_id: params[:id])
    @rols.each do |rol|
      @personas << Personaje.where(id: rol.personaje_id)
    end
    @personas.count
    @mujeres = @personas
    @hombres = @personas
    @total = @personas.count
    @porcentaje_mujeres= (100* (@mujeres.count))/@total

     @directors = @rols.where(name: "Direccion")
     @artes = @rols.where(name: "Arte")
     @asistentdires = @rols.where(name: "Asistente de Direccion")
     @direfotos = @rols.where(name: "Direccion de Fotografia")
     @efectoss = @rols.where(name: "Efectos")
     @guiones = @rols.where(name: "Guion")
     @jefedeproduccion = @rols.where(name: "Jefatura de Produccion")
     @maquillajes = @rols.where(name: "Maquillaje")
     @montajistas = @rols.where(name: "Montaje")
     @musicas = @rols.where(name: "Musica")
     @productors = @rols.where(name: "Produccion")
     @productorasociados = @rols.where(name: "Produccion Asociada")
     @productorejecutivos = @rols.where(name: "Produccion Ejecutiva")
     @realizacions = @rols.where(name: "Realizacion")
     @sonidos = @rols.where(name: "Sonido")
     @vestuarios = @rols.where(name: "Direccion")
     @vozenoffs = @rols.where(name: "Voz en off")
     @elenco = @rols.where(name: "Elenco")
     @casaprod = @rols.where(name: "Casa Productora")


end

  def new
    @pelicula = Pelicula.new
  end

  def create
    @pelicula = Pelicula.new(pelicula_params)
    if @pelicula.save
      redirect_to pelicula_path(@pelicula)
    else
      render :new
    end
  end

  def destroy
    @pelicula = Pelicula.find(params[:id])
    @pelicula.destroy
    redirect_to peliculas_path
  end

  def edit
    @pelicula = Pelicula.find(params[:id])
  end

  def update
    @pelicula = Pelicula.find(params[:id])
    @pelicula.update(pelicula_params)
    redirect_to pelicula_path(@pelicula)
  end

  def destroy
    raise
  end

  private

  def pelicula_params
    params.require(:pelicula).permit(:agno, :titulo, :responsable, :monto, :institucion, :imbd, :idcinechile, :contacto)
  end
end
