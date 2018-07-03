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
  end

  def show
    @pelicula = Pelicula.find(params[:id])
    @mujeres = @pelicula.where(mujer: true)
    @hombres = @pelicula.where(mujer: false)
    @total = @rol.count
    if @mujeres != 0 && @total != nil
    @porcentaje_mujeres= (100* (@mujeres.count))/@total
    end
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

  private

  def pelicula_params
    params.require(:pelicula).permit(:agno, :titulo, :responsable, :monto, :institucion, :imbd, :idcinechile, :contacto)
  end
end
