class PersonajesController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @personaje = Personaje.all
    @mujeres = Personaje.where(genero: true)
    @hombres = Personaje.where(genero: false)
    @total = @personaje.count
    @porcentaje_mujeres= (100* (@mujeres.count))/@total
    @personaje.map do |rol|
    if rol.name== nil
      rol.name = "ninguno"
   end
   @personajes = (@personaje.uniq).sort_by(&:name)
 end
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
   @r.genero = "Otro"
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
