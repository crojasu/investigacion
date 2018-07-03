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
   @r = Rol.find(params[:id])
   @r.genero = false
   @r.save
   redirect_to personajes_path
  end

  def activate
  @r = Rol.find(params[:id])
   @r.genero = true
   @r.save
   redirect_to personajes_path
  end

  private

  def allowed_params
    params.require(:personaje).permit(:name, :genero)
  end
end
