class PersonajesController < ApplicationController
  def index
    @persona = Personaje.all
    @mujeres = Personaje.where(genero: true)
    @hombres = Personaje.where(genero: false)
    @total = @persona.count
    @porcentaje_mujeres= (100* (@mujeres.count))/@total
  end

  def show
  end

  def deactivate
   @r = Personaje.find(params[:id])
   @r.genero = "Hombre"
   @r.save
   redirect_to personajes_path
  end

  def activate
  @r = Personaje.find(params[:id])
   @r.genero = "Mujer"
   @r.save
   redirect_to personajes_path
  end

def empresa
  @r = Personaje.find(params[:id])
   @r.genero = "Empresa"
   @r.save
   redirect_to personajes_path
  end


  def destroy
    @nombre = Personaje.find(params[:id])
    @nombre.destroy
    #redirect_to  peliculas_path
  end

  private

  def allowed_params
    params.require(:personaje).permit(:name, :genero)
  end
end
