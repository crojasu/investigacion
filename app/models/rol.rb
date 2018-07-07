class Rol < ApplicationRecord
  belongs_to :personaje
  belongs_to :pelicula

def self.import(file)

    data= Array.new
     CSV.foreach(file.path, headers: true, header_converters: :symbol, converters: :all, :encoding => 'ISO-8859-1') do |row|
       data << row.to_h
      end

     data.each do |data|
      nombre = I18n.transliterate(data[:nombre_personaje]).upcase
      cinechile = Pelicula.find_by(idcinechile: data[:pelicula_id])
      @roldepeliculas = Rol.where(pelicula_id: cinechile.id)
      @rol= @roldepeliculas.where(name: nombrerol)
      @persona = Personaje.find_by(name: nombre)
      if @persona && @rol.any? {|rol| rol.personaje_id = @persona.id}
        puts "hola"
      elsif @persona
        da = Rol.create(name: nombrerol)
        da.pelicula = cinechile
        da.personaje = @persona
        da.save
      else
        pe3 = Personaje.create(name: nombre)
        da3 = Rol.create(name: nombrerol)
        da3.pelicula = cinechile
        da3.personaje = pe3
        da3.save
      end
    end
  end
end
