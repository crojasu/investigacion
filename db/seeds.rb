require 'csv'
require 'json'
require 'open-uri'
require 'i18n'

#total de peliculas
@count=0
sinficha =[]
csv_text = File.read(Rails.root.join('lib', 'seeds', 'compilado.csv'))
csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')

csv.each do |row|
  tit = I18n.transliterate(row["titulo"]).upcase
  if Pelicula.find_by(idcinechile: row["idcinechile"])
    peli = Pelicula.find_by(idcinechile: row["idcinechile"])
    fond = Fondo.create(monto: row["monto"], tipo: row["institucion"])
    fond.pelicula_id = peli.id
    fond.save
    puts "se agrega un segundo fondo a #{peli.titulo} de #{fond.tipo}"
  else
    t = Pelicula.create(idcinechile: row["idcinechile"], agno: row["ano"], responsable: row["responsable"], tipo: row["tipo"], titulo: tit , salas: row["salas"], copias: row["copias"], publico: row["publico"])
    fond = Fondo.create(monto: row["monto"], tipo: row["institucion"])
    fond.pelicula_id = t.id
    t.save
    fond.save
    puts "///////"
    puts "Creando pelicula #{t.titulo} #{t.idcinechile}"
    puts "con fondos de #{fond.tipo} por #{fond.monto}"
  # #matching database from imdb
    imbd  = I18n.transliterate(t.titulo).split.join('+')
    url = "http://www.omdbapi.com/?t=#{imbd}&apikey=e91b7024"
    user_serialized = open(url).read
    value = JSON.parse(user_serialized)
    t.imbd = value
    t.save
    @roldepeliculas = Rol.where(pelicula_id: t.id)
    if value["Response"]== "True"
      if value["Director"] != "N/A"
      value["Director"].split(",").each do |dir|
      dire = I18n.transliterate(dir).upcase
      @persona = Personaje.find_by(name: dire)
      @rol= @roldepeliculas.where(name: "Direccion")
      if @persona && @rol.any? {|rol| rol.personaje_id = @persona.id}
        puts " #{dire} ya existe "
        elsif @persona
          da = Rol.create(name: "Direccion")
          da.pelicula = t
          da.personaje = @persona
          da.save
           puts "** agregando nuevo rol a director@s #{da.personaje.name}"
        else
        pe = Personaje.create(name: dire)
        da = Rol.create(name: "Direccion")
        da.pelicula = t
        da.personaje = pe
        da.save
         puts "agregando director@s #{da.personaje.name}"
        end
        end
      end
      if value["Writer"] != "N/A"
      value["Writer"].split(",").each do |gu|
      gui = I18n.transliterate(gu).upcase
      @persona = Personaje.find_by(name: gui)
      @rol= @roldepeliculas.where(name: "Guion")
      if @persona && @rol.any? {|rol| rol.personaje_id = @persona.id}
        puts " #{gui} ya existe "
        elsif @persona
          da = Rol.create(name: "Guion")
          da.pelicula = t
          da.personaje = @persona
          da.save
           puts "** agregando ** nuevo rol a guion #{da.personaje.name}"
        else
          pe2 = Personaje.create(name: gui)
          da2 = Rol.create(name: "Guion")
          da2.pelicula = t
          da2.personaje = pe2
          da2.save
           puts "agregando guion #{da2.personaje.name}"
          end
          end
        end
      if value["Actors"] != "N/A"
      value["Actors"].split(",").each do |ac|
      act = I18n.transliterate(ac).upcase
      @persona = Personaje.find_by(name: act)
      @rol= @roldepeliculas.where(name: "Elenco")
      if @persona && @rol.any? {|rol| rol.personaje_id = @persona.id}
        puts " #{act} ya existe "
        elsif @persona
          da = Rol.create(name: "Elenco")
          da.pelicula = t
          da.personaje = @persona
          da.save
           puts "**agregando ** nuevo rol a elenco #{da.personaje.name}"
        else
      pe3 = Personaje.create(name: act)
      da3 = Rol.create(name: "Elenco")
      da3.pelicula = t
      da3.personaje = pe3
      da3.save
       puts "agregando elenco #{da3.personaje.name}"
          end
        end
      end
      if value["Production"] != nil && value["Production"] != "N/A"
        value["Production"].split(",").each do |po|
        pro = I18n.transliterate(po).upcase
        @persona = Personaje.find_by(name: pro)
        @rol= @roldepeliculas.where(name: "Casa Productora")
        if @persona && @rol.any? {|rol| rol.personaje_id = @persona.id}
        puts " #{pro} ya existe "
        elsif @persona
          da = Rol.create(name: "Casa Productora")
          da.pelicula = t
          da.personaje = @persona
          da.save
           puts "** agregando ** nuevo rol a productora #{da.personaje.name}"
        else
        pe4 = Personaje.create(name: pro)
        da4 = Rol.create(name: "Casa Productora")
        da4.pelicula = t
        da4.personaje = pe4
        da4.save
         puts "agregando productora #{da4.personaje.name}"
          end
      end
    end
    else
      @count = @count+1
      sinficha << ("#{t.titulo}")
      puts "sin ficha"
    end
    t.save
    end
  end

# puts @count
# #puts sinficha

#  puts "Ahora agregamos las fichas con imbd tt
#  ????????????????
#  ///////////////"

# sinficha2=[]
# @count2 =0
# imbd2 = Array.new
# csv_text_imbd = File.read(Rails.root.join('lib', 'seeds', 'imdb.csv'))
# csvd = CSV.parse(csv_text_imbd, headers: true, header_converters: :symbol, converters: :all, :encoding => 'ISO-8859-1')
# csvd.each do |row|
#   tit = I18n.transliterate(row[:titulo]).upcase
#   t = Pelicula.find_by_titulo(tit)
#   if t && row[:im] != nil
#   imbd2  = row[:im]
#   url2 = "http://www.omdbapi.com/?i=#{imbd2}&apikey=e91b7024"
#   user_serialized2 = open(url2).read
#   value = JSON.parse(user_serialized2)
#   t.imbd = value
#   t.save
#   @roldepeliculas = Rol.where(pelicula_id: t.id)
#     if value["Response"]== "True"
#     if value["Director"] != "N/A"
#       value["Director"].split(",").each do |dir|
#       dire = I18n.transliterate(dir).upcase
#       @persona = Personaje.find_by(name: dire)
#       @rol= @roldepeliculas.where(name: "Direccion")
#       if @persona && @rol.any? {|rol| rol.personaje_id = @persona.id}
#         puts " #{dire} ya existe "
#         elsif @persona
#           da = Rol.create(name: "Direccion")
#           da.pelicula = t
#           da.personaje = @persona
#           da.save
#            puts "** agregando *** nuevo rol a director@s #{da.personaje.name}"
#         else
#         pe = Personaje.create(name: dire)
#         da = Rol.create(name: "Direccion")
#         da.pelicula = t
#         da.personaje = pe
#         da.save
#          puts "agregando director@s #{da.personaje.name}"
#         end
#         end
#       end
#       if value["Writer"] != "N/A"
#       value["Writer"].split(",").each do |gu|
#       gui = I18n.transliterate(gu).upcase
#       @persona = Personaje.find_by(name: gui)
#       @rol= @roldepeliculas.where(name: "Guion")
#       if @persona && @rol.any? {|rol| rol.personaje_id = @persona.id}
#         puts " #{gui} ya existe "
#         elsif @persona
#           da = Rol.create(name: "Guion")
#           da.pelicula = t
#           da.personaje = @persona
#           da.save
#            puts "** agregando ** nuevo rol a guion #{da.personaje.name}"
#         else
#           pe2 = Personaje.create(name: gui)
#           da2 = Rol.create(name: "Guion")
#           da2.pelicula = t
#           da2.personaje = pe2
#           da2.save
#            puts "agregando guion #{da2.personaje.name}"
#           end
#           end
#         end
#       if value["Actors"] != "N/A"
#       value["Actors"].split(",").each do |ac|
#       act = I18n.transliterate(ac).upcase
#       @persona = Personaje.find_by(name: act)
#       @rol= @roldepeliculas.where(name: "Elenco")
#       if @persona && @rol.any? {|rol| rol.personaje_id = @persona.id}
#         puts " #{act} ya existe "
#         elsif @persona
#           da = Rol.create(name: "Elenco")
#           da.pelicula = t
#           da.personaje = @persona
#           da.save
#            puts "** agregando ** nuevo rol a elenco #{da.personaje.name}"
#         else
#       pe3 = Personaje.create(name: act)
#       da3 = Rol.create(name: "Elenco")
#       da3.pelicula = t
#       da3.personaje = pe3
#       da3.save
#        puts "agregando elenco #{da3.personaje.name}"
#           end
#         end
#       end
#       if value["Production"] != nil && value["Production"] != "N/A"
#         value["Production"].split(",").each do |po|
#         pro = I18n.transliterate(po).upcase
#         @persona = Personaje.find_by(name: pro)
#         @rol= @roldepeliculas.where(name: "Casa Productora")
#         if @persona && @rol.any? {|rol| rol.personaje_id = @persona.id}
#         puts " #{pro} ya existe "
#         elsif @persona
#           da = Rol.create(name: "Casa Productora")
#           da.pelicula = t
#           da.personaje = @persona
#           da.save
#            puts "** agregando ** nuevo rol a productora #{da.personaje.name}"
#         else
#         pe4 = Personaje.create(name: pro)
#         da4 = Rol.create(name: "Casa Productora")
#         da4.pelicula = t
#         da4.personaje = pe4
#         da4.save
#          puts "agregando productora #{da4.personaje.name}"
#           end
#       end
#     end
#     else
#       puts "esto no se que es #{value["Title"]}"
#       puts "#{t.titulo}"
#     end
#   else
#   @count2 = @count2+1
#   end
#  end

# puts "total de directores #{@directores}"
# puts "total de #{@count2}"
# puts "total de #{sinficha2}"
# puts "este es el numero de peliculas sin imbd #{sinficha2.count}"

# puts "ahora agregamos director@s /////////////////
# ////////////////
# //////////////
# ///////////"

# # director@s

# data= Array.new
# csv_text_direc = File.read(Rails.root.join('lib', 'seeds', 'directores.csv'))
# csvd = CSV.parse(csv_text_direc, headers: true, header_converters: :symbol, converters: :all, :encoding => 'ISO-8859-1')
# csvd.each do |row|
#  data << row.to_h
# end

# @count1 =0
# @existentes = 0
# @nuevos = 0
# @nuevorol =0

#  data.each do |data|
#   nombre = I18n.transliterate(data[:nombre_personaje]).upcase
#   cinechile = Pelicula.find_by(idcinechile: data[:pelicula_id])
#   @roldepeliculas = Rol.where(pelicula_id: cinechile.id)
#   @rol= @roldepeliculas.where(name: "Direccion")
#   @persona = Personaje.find_by(name: nombre)
#   if @persona && @rol.any? {|rol| rol.personaje_id = @persona.id}
#         puts " #{nombre} ya existe "
#         @existentes= @existentes +1
#   elsif @persona
#     da = Rol.create(name: "Direccion")
#     da.pelicula = cinechile
#     da.personaje = @persona
#     da.save
#     puts "agregando ** nuevo rol a director #{da.personaje.name}"
#     @nuevorol = @nuevorol +1
#   else
#     pe3 = Personaje.create(name: nombre)
#     da3 = Rol.create(name: "Direccion")
#     da3.pelicula = cinechile
#     da3.personaje = pe3
#     da3.save
#    puts " nuevo Direccion #{da3.personaje.name}"
#    @nuevos =@nuevos + 1
#     end
# end

# puts "directores nuevos #{@nuevos}"
# puts "directores @existentes #{@existentes}"
# puts "cantidad nuevos roles #{@nuevorol}"

# # # #arte

# dataart= Array.new
# csv_text_direc = File.read(Rails.root.join('lib', 'seeds', 'arte.csv'))
# csvd = CSV.parse(csv_text_direc, headers: true, header_converters: :symbol, converters: :all, :encoding => 'ISO-8859-1')
# csvd.each do |row|
#   dataart << row.to_h
#  end

# @existentes = 0
# @nuevos = 0
# @nuevorol =0

#  dataart.each do |data|
#   nombre = I18n.transliterate(data[:nombre_personaje]).upcase
#   cinechile = Pelicula.find_by(idcinechile: data[:pelicula_id])
#   @roldepeliculas = Rol.where(pelicula_id: cinechile.id)
#   @rol= @roldepeliculas.where(name: "Arte")
#   @persona = Personaje.find_by(name: nombre)
#   if @persona && @rol.any? {|rol| rol.personaje_id = @persona.id}
#         puts " #{nombre} ya existe "
#         @existentes= @existentes +1
#   elsif @persona
#     da = Rol.create(name: "Arte")
#     da.pelicula = cinechile
#     da.personaje = @persona
#     da.save
#     puts "agregando ** nuevo rol a Arte #{da.personaje.name}"
#     @nuevorol = @nuevorol +1
#   else
#     pe3 = Personaje.create(name: nombre)
#     da3 = Rol.create(name: "Arte")
#     da3.pelicula = cinechile
#     da3.personaje = pe3
#     da3.save
#    puts " nuevo Arte #{da3.personaje.name}"
#    @nuevos =@nuevos + 1
#     end
# end

# puts "Arte nuevos #{@nuevos}"
# puts "Arte @existentes #{@existentes}"
# puts "cantidad nuevos Arte #{@nuevorol}"


# # #productor
# datapro = Array.new
# csv_text_prod = File.read(Rails.root.join('lib', 'seeds', 'productor.csv'))
# csvd = CSV.parse(csv_text_prod, headers: true, header_converters: :symbol, converters: :all, :encoding => 'ISO-8859-1')
# csvd.each do |row|
#   datapro  << row.to_h
#  end

# @existentes = 0
# @nuevos = 0
# @nuevorol =0

#  datapro.each do |data|
#   nombre = I18n.transliterate(data[:nombre_personaje]).upcase
#   cinechile = Pelicula.find_by(idcinechile: data[:pelicula_id])
#   @roldepeliculas = Rol.where(pelicula_id: cinechile.id)
#   @rol= @roldepeliculas.where(name: "Produccion")
#   @persona = Personaje.find_by(name: nombre)
#   if @persona && @rol.any? {|rol| rol.personaje_id = @persona.id}
#         puts " #{nombre} ya existe "
#         @existentes= @existentes +1
#   elsif @persona
#     da = Rol.create(name: "Produccion")
#     da.pelicula = cinechile
#     da.personaje = @persona
#     da.save
#     puts "agregando ** nuevo rol a Produccion #{da.personaje.name}"
#     @nuevorol = @nuevorol +1
#   else
#     pe3 = Personaje.create(name: nombre)
#     da3 = Rol.create(name: "Produccion")
#     da3.pelicula = cinechile
#     da3.personaje = pe3
#     da3.save
#    puts " nuevo Produccion #{da3.personaje.name}"
#    @nuevos =@nuevos + 1
#     end
# end

# puts "Produccion nuevos #{@nuevos}"
# puts "Produccion @existentes #{@existentes}"
# puts "cantidad nuevos Produccion #{@nuevorol}"

# # # asistente de direc
# asistentedire = Array.new
# csv_text_asdir = File.read(Rails.root.join('lib', 'seeds', 'asistdire.csv'))
# csvd2 = CSV.parse(csv_text_asdir, headers: true, header_converters: :symbol, converters: :all, :encoding => 'ISO-8859-1')
# csvd2.each do |row|
#   asistentedire  << row.to_h
#  end

# @existentes = 0
# @nuevos = 0
# @nuevorol =0

#  asistentedire.each do |data|
#   nombre = I18n.transliterate(data[:nombre_personaje]).upcase
#   cinechile = Pelicula.find_by(idcinechile: data[:pelicula_id])
#   @roldepeliculas = Rol.where(pelicula_id: cinechile.id)
#   @rol= @roldepeliculas.where(name: "Asistente Direccion")
#   @persona = Personaje.find_by(name: nombre)
#   if @persona && @rol.any? {|rol| rol.personaje_id = @persona.id}
#         puts " #{nombre} ya existe "
#         @existentes= @existentes +1
#   elsif @persona
#     da = Rol.create(name: "Asistente Direccion")
#     da.pelicula = cinechile
#     da.personaje = @persona
#     da.save
#     puts "agregando ** nuevo rol a Asistente Direccion #{da.personaje.name}"
#     @nuevorol = @nuevorol +1
#   else
#     pe3 = Personaje.create(name: nombre)
#     da3 = Rol.create(name: "Asistente Direccion")
#     da3.pelicula = cinechile
#     da3.personaje = pe3
#     da3.save
#    puts " nuevo Asistente Direccion #{da3.personaje.name}"
#    @nuevos =@nuevos + 1
#     end
# end

# puts "Asistente Direccion nuevos #{@nuevos}"
# puts "Asistente Direccion @existentes #{@existentes}"
# puts "cantidad nuevos Asistente Direccion #{@nuevorol}"

# # #director de foto
# direfoto = Array.new
# csv_text_direfoto = File.read(Rails.root.join('lib', 'seeds', 'direfotos.csv'))
# csvd = CSV.parse(csv_text_direfoto, headers: true, header_converters: :symbol, converters: :all, :encoding => 'iso-8859-1:UTF-8')
# csvd.each do |row|
#   direfoto  << row.to_h
#  end

# @existentes = 0
# @nuevos = 0
# @nuevorol =0

#  direfoto.each do |data|
#   nombre = I18n.transliterate(data[:nombre_personaje]).upcase
#   cinechile = Pelicula.find_by(idcinechile: data[:pelicula_id])
#   @roldepeliculas = Rol.where(pelicula_id: cinechile.id)
#   @rol= @roldepeliculas.where(name: "Direccion Fotografia")
#   @persona = Personaje.find_by(name: nombre)
#   if @persona && @rol.any? {|rol| rol.personaje_id = @persona.id}
#         puts " #{nombre} ya existe "
#         @existentes= @existentes +1
#   elsif @persona
#     da = Rol.create(name: "Direccion Fotografia")
#     da.pelicula = cinechile
#     da.personaje = @persona
#     da.save
#     puts "agregando ** nuevo rol a Direccion Fotografia #{da.personaje.name}"
#     @nuevorol = @nuevorol +1
#   else
#     pe3 = Personaje.create(name: nombre)
#     da3 = Rol.create(name: "Direccion Fotografia")
#     da3.pelicula = cinechile
#     da3.personaje = pe3
#     da3.save
#    puts " nuevo Direccion Fotografia #{da3.personaje.name}"
#    @nuevos =@nuevos + 1
#     end
# end

# puts "Direccion Fotografia nuevos #{@nuevos}"
# puts "Direccion Fotografia @existentes #{@existentes}"
# puts "cantidad nuevos Direccion Fotografia #{@nuevorol}"

# # #efectos
# efectosa = Array.new
# csv_text_efectos = File.read(Rails.root.join('lib', 'seeds', 'efectos.csv'))
# csvd = CSV.parse(csv_text_efectos, headers: true, header_converters: :symbol, converters: :all, :encoding => 'iso-8859-1:UTF-8')
# csvd.each do |row|
#   efectosa  << row.to_h
#  end

# @existentes = 0
# @nuevos = 0
# @nuevorol =0

#  efectosa.each do |data|
#   nombre = I18n.transliterate(data[:nombre_personaje]).upcase
#   cinechile = Pelicula.find_by(idcinechile: data[:pelicula_id])
#   @roldepeliculas = Rol.where(pelicula_id: cinechile.id)
#   @rol= @roldepeliculas.where(name: "Efectos Especiales")
#   @persona = Personaje.find_by(name: nombre)
#   if @persona && @rol.any? {|rol| rol.personaje_id = @persona.id}
#         puts " #{nombre} ya existe "
#         @existentes= @existentes +1
#   elsif @persona
#     da = Rol.create(name: "Efectos Especiales")
#     da.pelicula = cinechile
#     da.personaje = @persona
#     da.save
#     puts "agregando ** nuevo rol a Efectos Especiales #{da.personaje.name}"
#     @nuevorol = @nuevorol +1
#   else
#     pe3 = Personaje.create(name: nombre)
#     da3 = Rol.create(name: "Efectos Especiales")
#     da3.pelicula = cinechile
#     da3.personaje = pe3
#     da3.save
#    puts " nuevo Efectos Especiales #{da3.personaje.name}"
#    @nuevos =@nuevos + 1
#     end
# end

# puts "Efectos Especiales nuevos #{@nuevos}"
# puts "Efectos Especiales @existentes #{@existentes}"
# puts "cantidad nuevos Efectos Especiales #{@nuevorol}"

# # #guion
# dataguion = Array.new
# csv_text_guion = File.read(Rails.root.join('lib', 'seeds', 'guion.csv'))
# csvd = CSV.parse(csv_text_guion, headers: true, header_converters: :symbol, converters: :all, :encoding => 'iso-8859-1:UTF-8')
# csvd.each do |row|
#   dataguion  << row.to_h
#  end
# @existentes = 0
# @nuevos = 0
# @nuevorol =0

#  dataguion.each do |data|
#   nombre = I18n.transliterate(data[:nombre_personaje]).upcase
#   cinechile = Pelicula.find_by(idcinechile: data[:pelicula_id])
#   @roldepeliculas = Rol.where(pelicula_id: cinechile.id)
#   @rol= @roldepeliculas.where(name: "Guion")
#   @persona = Personaje.find_by(name: nombre)
#   if @persona && @rol.any? {|rol| rol.personaje_id = @persona.id}
#         puts " #{nombre} ya existe "
#         @existentes= @existentes +1
#   elsif @persona
#     da = Rol.create(name: "Guion")
#     da.pelicula = cinechile
#     da.personaje = @persona
#     da.save
#     puts "agregando ** nuevo rol a Guion #{da.personaje.name}"
#     @nuevorol = @nuevorol +1
#   else
#     pe3 = Personaje.create(name: nombre)
#     da3 = Rol.create(name: "Guion")
#     da3.pelicula = cinechile
#     da3.personaje = pe3
#     da3.save
#    puts " nuevo Guion #{da3.personaje.name}"
#    @nuevos =@nuevos + 1
#     end
# end

# puts "Guion nuevos #{@nuevos}"
# puts "Guion @existentes #{@existentes}"
# puts "cantidad nuevos Guion #{@nuevorol}"


# # # #jefedeproduccion
# jefedeproduccion = Array.new
# csv_text_jefedeproduccion = File.read(Rails.root.join('lib', 'seeds', 'jefedeproduccion.csv'))
# csvd = CSV.parse(csv_text_jefedeproduccion, headers: true, header_converters: :symbol, converters: :all, :encoding => 'iso-8859-1:UTF-8')
# csvd.each do |row|
#   jefedeproduccion  << row.to_h
#  end

# @existentes = 0
# @nuevos = 0
# @nuevorol =0

#  jefedeproduccion.each do |data|
#   nombre = I18n.transliterate(data[:nombre_personaje]).upcase
#   cinechile = Pelicula.find_by(idcinechile: data[:pelicula_id])
#   @roldepeliculas = Rol.where(pelicula_id: cinechile.id)
#   @rol= @roldepeliculas.where(name: "Jefe de Produccion")
#   @persona = Personaje.find_by(name: nombre)
#   if @persona && @rol.any? {|rol| rol.personaje_id = @persona.id}
#         puts " #{nombre} ya existe "
#         @existentes= @existentes +1
#   elsif @persona
#     da = Rol.create(name: "Jefe de Produccion")
#     da.pelicula = cinechile
#     da.personaje = @persona
#     da.save
#     puts "agregando ** nuevo rol a Jefe de Produccion #{da.personaje.name}"
#     @nuevorol = @nuevorol +1
#   else
#     pe3 = Personaje.create(name: nombre)
#     da3 = Rol.create(name: "Jefe de Produccion")
#     da3.pelicula = cinechile
#     da3.personaje = pe3
#     da3.save
#    puts " nuevo Jefe de Produccion #{da3.personaje.name}"
#    @nuevos =@nuevos + 1
#     end
# end

# puts "Jefe de Produccion nuevos #{@nuevos}"
# puts "Jefe de Produccion @existentes #{@existentes}"
# puts "cantidad nuevos Jefe de Produccion #{@nuevorol}"

# # # montaje
# montaje = Array.new
# csv_text_montaje = File.read(Rails.root.join('lib', 'seeds', 'montaje.csv'))
# csvd = CSV.parse(csv_text_montaje, headers: true, header_converters: :symbol, converters: :all, :encoding => 'iso-8859-1:UTF-8')
# csvd.each do |row|
#   montaje  << row.to_h
#  end

# @existentes = 0
# @nuevos = 0
# @nuevorol =0

#  montaje.each do |data|
#   nombre = I18n.transliterate(data[:nombre_personaje]).upcase
#   cinechile = Pelicula.find_by(idcinechile: data[:pelicula_id])
#   @roldepeliculas = Rol.where(pelicula_id: cinechile.id)
#   @rol= @roldepeliculas.where(name: "Montaje")
#   @persona = Personaje.find_by(name: nombre)
#   if @persona && @rol.any? {|rol| rol.personaje_id = @persona.id}
#         puts " #{nombre} ya existe "
#         @existentes= @existentes +1
#   elsif @persona
#     da = Rol.create(name: "Montaje")
#     da.pelicula = cinechile
#     da.personaje = @persona
#     da.save
#     puts "agregando ** nuevo rol a Montaje #{da.personaje.name}"
#     @nuevorol = @nuevorol +1
#   else
#     pe3 = Personaje.create(name: nombre)
#     da3 = Rol.create(name: "Montaje")
#     da3.pelicula = cinechile
#     da3.personaje = pe3
#     da3.save
#    puts " nuevo Montaje #{da3.personaje.name}"
#    @nuevos =@nuevos + 1
#     end
# end

# puts "Montaje nuevos #{@nuevos}"
# puts "Montaje @existentes #{@existentes}"
# puts "cantidad nuevos Montaje #{@nuevorol}"


# # # musica
# musica = Array.new
# csv_text_musica = File.read(Rails.root.join('lib', 'seeds', 'musica.csv'))
# csvd = CSV.parse(csv_text_musica, headers: true, header_converters: :symbol, converters: :all, :encoding => 'iso-8859-1:UTF-8')
# csvd.each do |row|
#   musica  << row.to_h
#  end

# @existentes = 0
# @nuevos = 0
# @nuevorol =0

#  musica.each do |data|
#   nombre = I18n.transliterate(data[:nombre_personaje]).upcase
#   cinechile = Pelicula.find_by(idcinechile: data[:pelicula_id])
#   @roldepeliculas = Rol.where(pelicula_id: cinechile.id)
#   @rol= @roldepeliculas.where(name: "Musica")
#   @persona = Personaje.find_by(name: nombre)
#   if @persona && @rol.any? {|rol| rol.personaje_id = @persona.id}
#         puts " #{nombre} ya existe "
#         @existentes= @existentes +1
#   elsif @persona
#     da = Rol.create(name: "Musica")
#     da.pelicula = cinechile
#     da.personaje = @persona
#     da.save
#     puts "agregando ** nuevo rol a Musica #{da.personaje.name}"
#     @nuevorol = @nuevorol +1
#   else
#     pe3 = Personaje.create(name: nombre)
#     da3 = Rol.create(name: "Musica")
#     da3.pelicula = cinechile
#     da3.personaje = pe3
#     da3.save
#    puts " nuevo Musica #{da3.personaje.name}"
#    @nuevos =@nuevos + 1
#     end
# end

# puts "Musica nuevos #{@nuevos}"
# puts "Musica @existentes #{@existentes}"
# puts "cantidad nuevos Musica #{@nuevorol}"


# # # # maquillaje
# maquillaje = Array.new
# csv_text_maquillaje = File.read(Rails.root.join('lib', 'seeds', 'maquillaje.csv'))
# csvd = CSV.parse(csv_text_maquillaje, headers: true, header_converters: :symbol, converters: :all, :encoding => 'iso-8859-1:UTF-8')
# csvd.each do |row|
#   maquillaje  << row.to_h
#  end

# @existentes = 0
# @nuevos = 0
# @nuevorol =0

#  maquillaje.each do |data|
#   nombre = I18n.transliterate(data[:nombre_personaje]).upcase
#   cinechile = Pelicula.find_by(idcinechile: data[:pelicula_id])
#   @roldepeliculas = Rol.where(pelicula_id: cinechile.id)
#   @rol= @roldepeliculas.where(name: "Maquillaje")
#   @persona = Personaje.find_by(name: nombre)
#   if @persona && @rol.any? {|rol| rol.personaje_id = @persona.id}
#         puts " #{nombre} ya existe "
#         @existentes= @existentes +1
#   elsif @persona
#     da = Rol.create(name: "Maquillaje")
#     da.pelicula = cinechile
#     da.personaje = @persona
#     da.save
#     puts "agregando ** nuevo rol a Maquillaje #{da.personaje.name}"
#     @nuevorol = @nuevorol +1
#   else
#     pe3 = Personaje.create(name: nombre)
#     da3 = Rol.create(name: "Maquillaje")
#     da3.pelicula = cinechile
#     da3.personaje = pe3
#     da3.save
#    puts " nuevo Maquillaje #{da3.personaje.name}"
#    @nuevos =@nuevos + 1
#     end
# end

# puts "Maquillaje nuevos #{@nuevos}"
# puts "Maquillaje @existentes #{@existentes}"
# puts "cantidad nuevos Maquillaje #{@nuevorol}"


# # # productora
# productora = Array.new
# csv_text_prod = File.read(Rails.root.join('lib', 'seeds', 'casaproductora.csv'))
# csvd = CSV.parse(csv_text_prod, headers: true, header_converters: :symbol, converters: :all, :encoding => 'ISO-8859-1')
# csvd.each do |row|
#   productora  << row.to_h
#  end

# @existentes = 0
# @nuevos = 0
# @nuevorol =0

#  productora.each do |data|
#   nombre = I18n.transliterate(data[:nombre_personaje]).upcase
#   cinechile = Pelicula.find_by(idcinechile: data[:pelicula_id])
#   @roldepeliculas = Rol.where(pelicula_id: cinechile.id)
#   @rol= @roldepeliculas.where(name: "Casa Productora")
#   @persona = Personaje.find_by(name: nombre)
#   if @persona && @rol.any? {|rol| rol.personaje_id = @persona.id}
#         puts " #{nombre} ya existe "
#         @existentes= @existentes +1
#   elsif @persona
#     da = Rol.create(name: "Casa Productora")
#     da.pelicula = cinechile
#     da.personaje = @persona
#     da.save
#     puts "agregando ** nuevo rol a Casa Productora #{da.personaje.name}"
#     @nuevorol = @nuevorol +1
#   else
#     pe3 = Personaje.create(name: nombre)
#     da3 = Rol.create(name: "Casa Productora")
#     da3.pelicula = cinechile
#     da3.personaje = pe3
#     da3.save
#    puts " nuevo Casa Productora #{da3.personaje.name}"
#    @nuevos =@nuevos + 1
#     end
# end

# puts "Casa Productora nuevos #{@nuevos}"
# puts "Casa Productora @existentes #{@existentes}"
# puts "cantidad nuevos Casa Productora #{@nuevorol}"


# # #productorasociado
# productorasociado = Array.new
# csv_text_prod = File.read(Rails.root.join('lib', 'seeds', 'casaproductorasociado.csv'))
# csvd = CSV.parse(csv_text_prod, headers: true, header_converters: :symbol, converters: :all, :encoding => 'ISO-8859-1')
# csvd.each do |row|
#   productorasociado  << row.to_h
#  end

# @existentes = 0
# @nuevos = 0
# @nuevorol =0

#  productorasociado.each do |data|
#   nombre = I18n.transliterate(data[:nombre_personaje]).upcase
#   cinechile = Pelicula.find_by(idcinechile: data[:pelicula_id])
#   @roldepeliculas = Rol.where(pelicula_id: cinechile.id)
#   @rol= @roldepeliculas.where(name: "Produccion Asociada")
#   @persona = Personaje.find_by(name: nombre)
#   if @persona && @rol.any? {|rol| rol.personaje_id = @persona.id}
#         puts " #{nombre} ya existe "
#         @existentes= @existentes +1
#   elsif @persona
#     da = Rol.create(name: "Produccion Asociada")
#     da.pelicula = cinechile
#     da.personaje = @persona
#     da.save
#     puts "agregando ** nuevo rol a Produccion Asociada #{da.personaje.name}"
#     @nuevorol = @nuevorol +1
#   else
#     pe3 = Personaje.create(name: nombre)
#     da3 = Rol.create(name: "Produccion Asociada")
#     da3.pelicula = cinechile
#     da3.personaje = pe3
#     da3.save
#    puts " nuevo Produccion Asociada #{da3.personaje.name}"
#    @nuevos =@nuevos + 1
#     end
# end

# puts "Produccion Asociada nuevos #{@nuevos}"
# puts "Produccion Asociada @existentes #{@existentes}"
# puts "cantidad nuevos Produccion Asociada #{@nuevorol}"


# # #productorejecutivo
# productorejecutivo = Array.new
# csv_text_prod = File.read(Rails.root.join('lib', 'seeds', 'productorejecutivo.csv'))
# csvd = CSV.parse(csv_text_prod, headers: true, header_converters: :symbol, converters: :all, :encoding => 'ISO-8859-1')
# csvd.each do |row|
#   productorejecutivo  << row.to_h
#  end

#  @existentes = 0
# @nuevos = 0
# @nuevorol =0

#  productorejecutivo.each do |data|
#   nombre = I18n.transliterate(data[:nombre_personaje]).upcase
#   cinechile = Pelicula.find_by(idcinechile: data[:pelicula_id])
#   @roldepeliculas = Rol.where(pelicula_id: cinechile.id)
#   @rol= @roldepeliculas.where(name: "Produccion Ejecutiva")
#   @persona = Personaje.find_by(name: nombre)
#   if @persona && @rol.any? {|rol| rol.personaje_id = @persona.id}
#         puts " #{nombre} ya existe "
#         @existentes= @existentes +1
#   elsif @persona
#     da = Rol.create(name: "Produccion Ejecutiva")
#     da.pelicula = cinechile
#     da.personaje = @persona
#     da.save
#     puts "agregando ** nuevo rol a Produccion Ejecutiva #{da.personaje.name}"
#     @nuevorol = @nuevorol +1
#   else
#     pe3 = Personaje.create(name: nombre)
#     da3 = Rol.create(name: "Produccion Ejecutiva")
#     da3.pelicula = cinechile
#     da3.personaje = pe3
#     da3.save
#    puts " nuevo Produccion Ejecutiva #{da3.personaje.name}"
#    @nuevos =@nuevos + 1
#     end
# end

# puts "Produccion Ejecutiva nuevos #{@nuevos}"
# puts "Produccion Ejecutiva @existentes #{@existentes}"
# puts "cantidad nuevos Produccion Ejecutiva #{@nuevorol}"


# # # # realizacion
# realizacion = Array.new
# csv_text_prod = File.read(Rails.root.join('lib', 'seeds', 'realizacion2.csv'))
# csvd = CSV.parse(csv_text_prod, headers: true, header_converters: :symbol, converters: :all, :encoding => 'ISO-8859-1')
# csvd.each do |row|
#   realizacion  << row.to_h
#  end

# @existentes = 0
# @nuevos = 0
# @nuevorol =0

#  realizacion.each do |data|
#   nombre = I18n.transliterate(data[:nombre_personaje]).upcase
#   cinechile = Pelicula.find_by(idcinechile: data[:pelicula_id])
#   @roldepeliculas = Rol.where(pelicula_id: cinechile.id)
#   @rol= @roldepeliculas.where(name: "Produccion")
#   @persona = Personaje.find_by(name: nombre)
#   if @persona && @rol.any? {|rol| rol.personaje_id = @persona.id}
#         puts " #{nombre} ya existe "
#         @existentes= @existentes +1
#   elsif @persona
#     da = Rol.create(name: "Produccion")
#     da.pelicula = cinechile
#     da.personaje = @persona
#     da.save
#     puts "agregando ** nuevo rol a Produccion #{da.personaje.name}"
#     @nuevorol = @nuevorol +1
#   else
#     pe3 = Personaje.create(name: nombre)
#     da3 = Rol.create(name: "Produccion")
#     da3.pelicula = cinechile
#     da3.personaje = pe3
#     da3.save
#    puts " nuevo Produccion #{da3.personaje.name}"
#    @nuevos =@nuevos + 1
#     end
# end

# puts "Produccion nuevos #{@nuevos}"
# puts "Produccion @existentes #{@existentes}"
# puts "cantidad nuevos Produccion #{@nuevorol}"


# # #sonido
# sonido = Array.new
# csv_text_prod = File.read(Rails.root.join('lib', 'seeds', 'sonido2.csv'))
# csvd = CSV.parse(csv_text_prod, headers: true, header_converters: :symbol, converters: :all, :encoding => 'ISO-8859-1')
# csvd.each do |row|
#   sonido  << row.to_h
#  end

# @existentes = 0
# @nuevos = 0
# @nuevorol =0

#  sonido.each do |data|
#   nombre = I18n.transliterate(data[:nombre_personaje]).upcase
#   cinechile = Pelicula.find_by(idcinechile: data[:pelicula_id])
#   @roldepeliculas = Rol.where(pelicula_id: cinechile.id)
#   @rol= @roldepeliculas.where(name: "Sonido")
#   @persona = Personaje.find_by(name: nombre)
#   if @persona && @rol.any? {|rol| rol.personaje_id = @persona.id}
#         puts " #{nombre} ya existe "
#         @existentes= @existentes +1
#   elsif @persona
#     da = Rol.create(name: "Sonido")
#     da.pelicula = cinechile
#     da.personaje = @persona
#     da.save
#     puts "agregando ** nuevo rol a Sonido #{da.personaje.name}"
#     @nuevorol = @nuevorol +1
#   else
#     pe3 = Personaje.create(name: nombre)
#     da3 = Rol.create(name: "Sonido")
#     da3.pelicula = cinechile
#     da3.personaje = pe3
#     da3.save
#    puts " nuevo Sonido #{da3.personaje.name}"
#    @nuevos =@nuevos + 1
#     end
# end

# puts "Sonido nuevos #{@nuevos}"
# puts "Sonido @existentes #{@existentes}"
# puts "cantidad nuevos Sonido #{@nuevorol}"

# # # #vestuario
# vestuario = Array.new
# csv_text_prod = File.read(Rails.root.join('lib', 'seeds', 'vestuario2.csv'))
# csvd = CSV.parse(csv_text_prod, headers: true, header_converters: :symbol, converters: :all, :encoding => 'ISO-8859-1')
# csvd.each do |row|
#   vestuario  << row.to_h
#  end

# @existentes = 0
# @nuevos = 0
# @nuevorol =0

#  vestuario.each do |data|
#   nombre = I18n.transliterate(data[:nombre_personaje]).upcase
#   cinechile = Pelicula.find_by(idcinechile: data[:pelicula_id])
#   @roldepeliculas = Rol.where(pelicula_id: cinechile.id)
#   @rol= @roldepeliculas.where(name: "Vestuario")
#   @persona = Personaje.find_by(name: nombre)
#   if @persona && @rol.any? {|rol| rol.personaje_id = @persona.id}
#         puts " #{nombre} ya existe "
#         @existentes= @existentes +1
#   elsif @persona
#     da = Rol.create(name: "Vestuario")
#     da.pelicula = cinechile
#     da.personaje = @persona
#     da.save
#     puts "agregando ** nuevo rol a Vestuario #{da.personaje.name}"
#     @nuevorol = @nuevorol +1
#   else
#     pe3 = Personaje.create(name: nombre)
#     da3 = Rol.create(name: "Vestuario")
#     da3.pelicula = cinechile
#     da3.personaje = pe3
#     da3.save
#    puts " nuevo Vestuario #{da3.personaje.name}"
#    @nuevos =@nuevos + 1
#     end
# end

# puts "Vestuario nuevos #{@nuevos}"
# puts "Vestuario @existentes #{@existentes}"
# puts "cantidad nuevos Vestuario #{@nuevorol}"


# # # #vozenoff
#   vozenoff = Array.new
#   csv_text_prod = File.read(Rails.root.join('lib', 'seeds', 'vozenoff2.csv'))
#   csvd = CSV.parse(csv_text_prod, headers: true, header_converters: :symbol, converters: :all, :encoding => 'ISO-8859-1')
#   csvd.each do |row|
#     vozenoff  << row.to_h
#    end

# @existentes = 0
# @nuevos = 0
# @nuevorol =0

#  vozenoff.each do |data|
#   nombre = I18n.transliterate(data[:nombre_personaje]).upcase
#   cinechile = Pelicula.find_by(idcinechile: data[:pelicula_id])
#   @roldepeliculas = Rol.where(pelicula_id: cinechile.id)
#   @rol= @roldepeliculas.where(name: "Voz en Off")
#   @persona = Personaje.find_by(name: nombre)
#   if @persona && @rol.any? {|rol| rol.personaje_id = @persona.id}
#         puts " #{nombre} ya existe "
#         @existentes= @existentes +1
#   elsif @persona
#     da = Rol.create(name: "Voz en Off")
#     da.pelicula = cinechile
#     da.personaje = @persona
#     da.save
#     puts "agregando ** nuevo rol a Voz en Off #{da.personaje.name}"
#     @nuevorol = @nuevorol +1
#   else
#     pe3 = Personaje.create(name: nombre)
#     da3 = Rol.create(name: "Voz en Off")
#     da3.pelicula = cinechile
#     da3.personaje = pe3
#     da3.save
#    puts " nuevo Voz en Off #{da3.personaje.name}"
#    @nuevos =@nuevos + 1
#     end
# end

# puts "Voz en Off nuevos #{@nuevos}"
# puts "Voz en Off @existentes #{@existentes}"
# puts "cantidad nuevos Voz en Off #{@nuevorol}"

# # # #animacion
#   animacion = Array.new
#   csv_text_prod = File.read(Rails.root.join('lib', 'seeds', 'animacion2.csv'))
#   csvd = CSV.parse(csv_text_prod, headers: true, header_converters: :symbol, converters: :all, :encoding => 'ISO-8859-1')
#   csvd.each do |row|
#     animacion  << row.to_h
#    end
# @existentes = 0
# @nuevos = 0
# @nuevorol =0

#  animacion.each do |data|
#   nombre = I18n.transliterate(data[:nombre_personaje]).upcase
#   cinechile = Pelicula.find_by(idcinechile: data[:pelicula_id])
#   @roldepeliculas = Rol.where(pelicula_id: cinechile.id)
#   @rol= @roldepeliculas.where(name: "Animacion")
#   @persona = Personaje.find_by(name: nombre)
#   if @persona && @rol.any? {|rol| rol.personaje_id = @persona.id}
#         puts " #{nombre} ya existe "
#         @existentes= @existentes +1
#   elsif @persona
#     da = Rol.create(name: "Animacion")
#     da.pelicula = cinechile
#     da.personaje = @persona
#     da.save
#     puts "agregando ** nuevo rol a Animacion #{da.personaje.name}"
#     @nuevorol = @nuevorol +1
#   else
#     pe3 = Personaje.create(name: nombre)
#     da3 = Rol.create(name: "Animacion")
#     da3.pelicula = cinechile
#     da3.personaje = pe3
#     da3.save
#    puts " nuevo Animacion #{da3.personaje.name}"
#    @nuevos =@nuevos + 1
#     end
# end

# puts "Animacion nuevos #{@nuevos}"
# puts "Animacion @existentes #{@existentes}"
# puts "cantidad nuevos Animacion #{@nuevorol}"


# # # #decoracion
#   decoracion = Array.new
#   csv_text_prod = File.read(Rails.root.join('lib', 'seeds', 'decorados2.csv'))
#   csvd = CSV.parse(csv_text_prod, headers: true, header_converters: :symbol, converters: :all, :encoding => 'ISO-8859-1')
#   csvd.each do |row|
#     decoracion  << row.to_h
#    end

# @existentes = 0
# @nuevos = 0
# @nuevorol =0

#  decoracion.each do |data|
#   nombre = I18n.transliterate(data[:nombre_personaje]).upcase
#   cinechile = Pelicula.find_by(idcinechile: data[:pelicula_id])
#   @roldepeliculas = Rol.where(pelicula_id: cinechile.id)
#   @rol= @roldepeliculas.where(name: "Decoracion")
#   @persona = Personaje.find_by(name: nombre)
#   if @persona && @rol.any? {|rol| rol.personaje_id = @persona.id}
#         puts " #{nombre} ya existe "
#         @existentes= @existentes +1
#   elsif @persona
#     da = Rol.create(name: "Decoracion")
#     da.pelicula = cinechile
#     da.personaje = @persona
#     da.save
#     puts "agregando ** nuevo rol a Decoracion #{da.personaje.name}"
#     @nuevorol = @nuevorol +1
#   else
#     pe3 = Personaje.create(name: nombre)
#     da3 = Rol.create(name: "Decoracion")
#     da3.pelicula = cinechile
#     da3.personaje = pe3
#     da3.save
#    puts " nuevo Decoracion #{da3.personaje.name}"
#    @nuevos =@nuevos + 1
#     end
# end

# puts "Decoracion nuevos #{@nuevos}"
# puts "Decoracion @existentes #{@existentes}"
# puts "cantidad nuevos Decoracion #{@nuevorol}"


# # # #elenco2
#   elenco2 = Array.new
#   csv_text_prod = File.read(Rails.root.join('lib', 'seeds', 'elenco2.csv'))
#   csvd = CSV.parse(csv_text_prod, headers: true, header_converters: :symbol, converters: :all, :encoding => 'ISO-8859-1')
#   csvd.each do |row|
#     elenco2  << row.to_h
#    end
# @existentes = 0
# @nuevos = 0
# @nuevorol =0

#  elenco2.each do |data|
#   nombre = I18n.transliterate(data[:nombre_personaje]).upcase
#   cinechile = Pelicula.find_by(idcinechile: data[:pelicula_id])
#   @roldepeliculas = Rol.where(pelicula_id: cinechile.id)
#   @rol= @roldepeliculas.where(name: "Elenco")
#   @persona = Personaje.find_by(name: nombre)
#   if @persona && @rol.any? {|rol| rol.personaje_id = @persona.id}
#         puts " #{nombre} ya existe "
#         @existentes= @existentes +1
#   elsif @persona
#     da = Rol.create(name: "Elenco")
#     da.pelicula = cinechile
#     da.personaje = @persona
#     da.save
#     puts "agregando ** nuevo rol a Elenco #{da.personaje.name}"
#     @nuevorol = @nuevorol +1
#   else
#     pe3 = Personaje.create(name: nombre)
#     da3 = Rol.create(name: "Elenco")
#     da3.pelicula = cinechile
#     da3.personaje = pe3
#     da3.save
#    puts " nuevo Elenco #{da3.personaje.name}"
#    @nuevos =@nuevos + 1
#     end
# end

# puts "Elenco nuevos #{@nuevos}"
# puts "Elenco @existentes #{@existentes}"
# puts "cantidad nuevos rol Elenco #{@nuevorol}"

# # # # #premios
# #   premios = Array.new
# #   csv_text_prod = File.read(Rails.root.join('lib', 'seeds', 'premios.csv'))
# #   csvd = CSV.parse(csv_text_prod, headers: true, header_converters: :symbol, converters: :all, :encoding => 'ISO-8859-1')
# #   csvd.each do |row|
# #     premios  << row.to_h
# #    end

# #   @premios= []
# #   @premios = Pelicula.where(name: "Elenco")
# #   premios.each do |data4|
# #   nombre4 = I18n.transliterate(data4[:nombre_personaje]).upcase
# #   cinechile4 = Pelicula.find_by(idcinechile: data4[:pelicula_id])
# #   @rol = Rol.where(pelicula_id: cinechile4.id)
# #   @personasi = Personaje.where(name: nombre4)

# #    if(@premios.any?{|rol| @personasi.include? (rol.personaje)})
# #         puts " #{nombre4} ya existe ///////
# #         //////"
# #     else
# #      puts  "no existe asi que lo agregamos como"
# #         peasist = Personaje.create(name: nombre4)
# #         dasist = Rol.create(name: "Elenco")
# #         dasist.pelicula = cinechile4
# #         dasist.personaje = peasist
# #         dasist.save
# #          puts " nuevo premios #{dasist.personaje.name}/////
# #          /////"
# #       end
# # end

# # puts @premios.count
