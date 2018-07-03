class RolsController < ApplicationController
  def index
     @rols= Rol.all
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
    @rol = Rol.find(params[:id])
  end

  private

  def allowed_params
    params.require(:rol).permit(:name, :personaje_id, :pelicula_id)
  end
end
