class PersonajesController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @personaje = Personaje.all
    @mujeres = Personaje.where(genero: true)
    @hombres = Personaje.where(genero: false)
    @total = @personaje.count
    @porcentaje_mujeres= (100* (@mujeres.count))/@total
    @personaje.each do |per|
      if per.name == nil
        per.name = "ninguno"
      end
      if (Rol.where(personaje_id: per.id)).empty?
      per.destroy
      end
    end
    @personajes = (@personaje.uniq).sort_by(&:name)
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

  respond_to do |format|
        format.html { redirect_to restaurant_path(@restaurant) }
        format.js  # <-- will render `app/views/reviews/create.js.erb`
      end
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
