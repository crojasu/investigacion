require 'csv'
require 'json'
require 'open-uri'
require 'i18n'

# Pelicula.destroy_all
# Rol.destroy_all
# Personaje.destroy_all

# #total de peliculas
# @count=0
# sinficha =[]
# csv_text = File.read(Rails.root.join('lib', 'seeds', 'pelisdecinechile.csv'))
# csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
# csv.each do |row|
#    tit = I18n.transliterate(row["nombre_pelicula"])
#   t = Pelicula.create(idcinechile: row["pelicula_id"], agno: row["ano"], titulo: tit, responsable: row["responsable"], monto: row["monto"], institucion: row["tipo"], contacto: row["contacto"] )
#     t.save
#     puts "Creando pelicula #{t.titulo} #{t.idcinechile}"

# # #matching database from imdb
#   imbd  = I18n.transliterate(t.titulo).split.join('+')
#   url = "http://www.omdbapi.com/?t=#{imbd}&apikey=e91b7024"
#   user_serialized = open(url).read
#   value = JSON.parse(user_serialized)
#   t.imbd = value
#   t.save
#   if value["Response"]== "True"
#     if value["Director"] != "N/A"
#     value["Director"].split(",").each do |dir|
#     dire = I18n.transliterate(dir)
#     pe = Personaje.create(name: dire)
#     da = Rol.create(name: "Direccion")
#     da.pelicula = t
#     da.personaje = pe
#     da.save
#      puts "agregando director@s #{da.personaje.name}"
#      puts da.id
#         end
#       end
#     if value["Writer"] != "N/A"
#     value["Writer"].split(",").each do |gu|
#     gui = I18n.transliterate(gu)
#     pe2 = Personaje.create(name: gui)
#     da2 = Rol.create(name: "Guion")
#     da2.pelicula = t
#     da2.personaje = pe2
#     da2.save
#      puts "agregando guion #{da2.personaje.name}"
#      puts da2.id
#         end
#       end
#     if value["Actors"] != "N/A"
#     value["Actors"].split(",").each do |ac|
#       act = I18n.transliterate(ac)
#     pe3 = Personaje.create(name: act)
#     da3 = Rol.create(name: "Elenco")
#     da3.pelicula = t
#     da3.personaje = pe3
#     da3.save
#      puts "agregando elenco #{da3.personaje.name}"
#         end
#       end
#     if value["Production"] != nil && value["Production"] != "N/A"
#       value["Production"].split(",").each do |po|
#         pro = I18n.transliterate(po)
#       pe4 = Personaje.create(name: pro)
#       da4 = Rol.create(name: "Casa Productora")
#       da4.pelicula = t
#       da4.personaje = pe4
#       da4.save
#        puts "agregando productora #{da4.personaje.name}"
#         end
#     end
#   else
#     @count = @count+1
#     sinficha << ("#{t.titulo}")
#     puts "sin ficha"
#   end
#   t.save
#   end

# puts @count
# #puts sinficha

#  puts "Ahora agregamos las fichas con imbd tt
#  ????????????????
#  ///////////////"
# sinficha2=[]
# @count2 =0
# imbd = Array.new
# csv_text_imbd = File.read(Rails.root.join('lib', 'seeds', 'imdb.csv'))
# csvd = CSV.parse(csv_text_imbd, headers: true, header_converters: :symbol, converters: :all, :encoding => 'ISO-8859-1')
# csvd.each do |row|
#   tit = I18n.transliterate(row[:titulo])
#   p2 = Pelicula.find_by_titulo(tit)
#   if p2 && row[:im] != nil
#   imbd2  = row[:im]
#   url2 = "http://www.omdbapi.com/?i=#{imbd2}&apikey=e91b7024"
#   user_serialized2 = open(url2).read
#   value2 = JSON.parse(user_serialized2)
#   p2.imbd = value2
#   p2.save
#     if value2["Response"]== "True"
#     if value2["Director"] != "N/A"
#     value2["Director"].split(",").each do |dir|
#       dire = I18n.transliterate(dir)
#     pe = Personaje.create(name: dire)
#     da = Rol.create(name: "Dirección")
#     da.pelicula = p2
#     da.personaje = pe
#     da.save
#      puts "agregando director@s #{da.personaje.name}"
#         end
#       end
#     if value2["Writer"] != "N/A"
#     value2["Writer"].split(",").each do |gu|
#       gui = I18n.transliterate(gu)
#     pe2 = Personaje.create(name: gui)
#     da2 = Rol.create(name: "Guion")
#     da2.pelicula = p2
#     da2.personaje = pe2
#     da2.save
#      puts "agregando guion #{da2.personaje.name}"
#         end
#       end
#     if value2["Actors"] != "N/A"
#     value2["Actors"].split(",").each do |ac|
#       act = I18n.transliterate(ac)
#     pe3 = Personaje.create(name: act)
#     da3 = Rol.create(name: "Elenco")
#     da3.pelicula = p2
#     da3.personaje = pe3
#     da3.save
#      puts "agregando elenco #{da3.personaje.name}"
#         end
#       end
#     if value2["Production"] != nil && value2["Production"] != "N/A"
#       value2["Production"].split(",").each do |po|
#         pro = I18n.transliterate(po)
#       pe4 = Personaje.create(name: pro)
#       da4 = Rol.create(name: "Casa Productora")
#       da4.pelicula = p2
#       da4.personaje = pe4
#       da4.save
#        puts "agregando productora #{da4.personaje.name}"
#         end
#     end
#     else
#       puts "esto no se que es #{value2["Title"]}"
#       puts "#{p2.titulo}"
#     end
#   else
#   @count2 = @count2+1
#   puts "la pelicula #{p2.titulo} no se agrego"
#   sinficha2 << ("#{p2.titulo}")
#   end
#  end

# puts @directores
# puts @count2
# puts sinficha2
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

# @rol= Rol.all
# @directors = []
# @directors = Rol.where(name: "Direccion")
# puts @directors.count

# @count1 =0
# @existentes = 0
# @nuevos = 0
#  data.each do |data|
#   nombre = I18n.transliterate(data[:nombre_personaje])
#   cinechile = Pelicula.find_by(idcinechile: data[:pelicula_id])
#   @rol = Rol.where(pelicula_id: cinechile.id)
#   @persona = Personaje.where(name: nombre)

#   if @rol.any?{|rol| @persona.include? (rol.personaje)}
#       puts " #{nombre} ya existe ///////
#       //////"
#       @existentes = @existentes +1
#   else
#    puts  "#{nombre} no existe asi que lo agregamos como"
#       pe3 = Personaje.create(name: nombre)
#       da3 = Rol.create(name: "Direccion")
#       da3.pelicula = cinechile
#       da3.personaje = pe3
#       da3.save
#        puts " nuevo director #{da3.personaje.name}/////
#        /////"
#        @nuevos =@nuevos + 1
#     end
# end

# puts "directores nuevoc #{@nuevos}"
# puts "directores @existentes #{@existentes}"
# puts "cantidad directores #{@directors.count}"
# puts "cantidad peliculas #{Pelicula.count}"
# # # # #arte

# dataart= Array.new
# csv_text_direc = File.read(Rails.root.join('lib', 'seeds', 'arte.csv'))
# csvd = CSV.parse(csv_text_direc, headers: true, header_converters: :symbol, converters: :all, :encoding => 'ISO-8859-1')
# csvd.each do |row|
#   dataart << row.to_h
#  end

# @artes= []
# @artes = Rol.where(name: "Arte")
#  dataart.each do |data2|
#   nombre2 = I18n.transliterate(data2[:nombre_personaje])
#   cinechile2 = Pelicula.find_by(idcinechile: data2[:pelicula_id])
#   @rol = Rol.where(pelicula_id: cinechile2.id)
#   @personart = Personaje.where(name: nombre2)

#   if @personaart != nil
#    if(@artes.any?{|rol| @personaart.include? (rol.personaje)})
#         puts " #{nombre2} ya existe ///////
#         //////"
#       end
#     else
#      puts  "no existe asi que lo agregamos como"
#         pear3 = Personaje.create(name: nombre2)
#         daar3 = Rol.create(name: "Arte")
#         daar3.pelicula = cinechile2
#         daar3.personaje = pear3
#         daar3.save
#          puts " nuevo arte #{daar3.personaje.name}/////
#          /////"
#       end
# end

# puts @artes.count


# # #productor
productor = Array.new
csv_text_prod = File.read(Rails.root.join('lib', 'seeds', 'productor.csv'))
csvd = CSV.parse(csv_text_prod, headers: true, header_converters: :symbol, converters: :all, :encoding => 'ISO-8859-1')
csvd.each do |row|
  productor  << row.to_h
 end

#  productor.each do |prod|
#   peliproductor = Pelicula.find_by(idcinechile: prod[:pelicula_id])
#   peliproductor.productor = prod[:nombre_personaje]
#   peliproductor.save
#   puts "agregando Productor #{peliproductor.productor} a #{peliproductor.titulo} "
# end

 productor.each do |prod|
   da = Productor.new(peliculaid: prod[:pelicula_id], nombre: prod[:nombre_personaje])
  da.save!
  puts "agregando Productor@s #{da.nombre}"
  end

# # # asistente de direc
# # asistentedire = Array.new
# # csv_text_asistdir = File.read(Rails.root.join('lib', 'seeds', 'asistentedire.csv'))
# # csvd = CSV.parse(csv_text_asistdir, headers: true, header_converters: :symbol, converters: :all, :encoding => 'iso-8859-1:UTF-8')
# # csvd.each do |row|
# #   asistentedire  << row.to_h
# #  end

# #  asistentedire.each do |prod|
# #   peliasistentedire = Pelicula.find_by(idcinechile: prod[:pelicula_id])
# #   peliasistentedire.asistarte = prod[:nombre_personaje]
# #   peliasistentedire.save
# #   puts "agregando asistentedire #{peliasistentedire.asistentedire} a #{peliasistentedire.titulo} "
# # end

# #  asistentedire.each do |asistentedire|
# #    da = Asistentdire.new(peliculaid: asistentedire[:pelicula_id], nombre: asistentedire[:nombre_personaje])
# #   da.save!
# #   puts "agregando asistentedire #{da.nombre}"
# #   end

# #director de foto
# direfoto = Array.new
# csv_text_direfoto = File.read(Rails.root.join('lib', 'seeds', 'direfoto.csv'))
# csvd = CSV.parse(csv_text_direfoto, headers: true, header_converters: :symbol, converters: :all, :encoding => 'iso-8859-1:UTF-8')
# csvd.each do |row|
#   direfoto  << row.to_h
#  end

#  direfoto.each do |prod|
#   pelidirefoto = Pelicula.find_by(idcinechile: prod[:pelicula_id])
#   pelidirefoto.direcfoto = prod[:nombre_personaje]
#   pelidirefoto.save
#   puts "agregando direfoto #{pelidirefoto.direcfoto} a #{pelidirefoto.titulo} "
# end

#  direfoto.each do |direfoto|
#    da = Direfoto.new(peliculaid: direfoto[:pelicula_id], nombre: direfoto[:nombre_personaje])
#   da.save!
#   puts "agregando direfoto #{da.nombre}"
#   end

# #efectos
# efectos = Array.new
# csv_text_efectos = File.read(Rails.root.join('lib', 'seeds', 'efectosespeciales.csv'))
# csvd = CSV.parse(csv_text_efectos, headers: true, header_converters: :symbol, converters: :all, :encoding => 'iso-8859-1:UTF-8')
# csvd.each do |row|
#   efectos  << row.to_h
#  end

#  efectos.each do |prod|
#   peliefectos = Pelicula.find_by(idcinechile: prod[:pelicula_id])
#   peliefectos.efectos = prod[:nombre_personaje]
#   peliefectos.save
#   puts "agregando efectos #{peliefectos.efectos} a #{peliefectos.titulo} "
# end

#  efectos.each do |efecto|
#    da = Efecto.new(peliculaid: efecto[:pelicula_id], nombre: efecto[:nombre_personaje])
#   da.save!
#   puts "agregando efectos #{da.nombre}"
#   end


# #guion
# guion = Array.new
# csv_text_guion = File.read(Rails.root.join('lib', 'seeds', 'guion.csv'))
# csvd = CSV.parse(csv_text_guion, headers: true, header_converters: :symbol, converters: :all, :encoding => 'iso-8859-1:UTF-8')
# csvd.each do |row|
#   guion  << row.to_h
#  end

#  guion.each do |prod|
#   peliguion = Pelicula.find_by(idcinechile: prod[:pelicula_id])
#   peliguion.guion = prod[:nombre_personaje]
#   peliguion.save
#   puts "agregando guion #{peliguion.guion} a #{peliguion.titulo} "
# end

#  guion.each do |guion|
#    da = Guion.new(peliculaid: guion[:pelicula_id], nombre: guion[:nombre_personaje])
#   da.save!
#   puts "agregando guion #{da.nombre}"
#   end


# # #jefedeproduccion
# jefedeproduccion = Array.new
# csv_text_jefedeproduccion = File.read(Rails.root.join('lib', 'seeds', 'jefedeproduccion.csv'))
# csvd = CSV.parse(csv_text_jefedeproduccion, headers: true, header_converters: :symbol, converters: :all, :encoding => 'iso-8859-1:UTF-8')
# csvd.each do |row|
#   jefedeproduccion  << row.to_h
#  end

#  jefedeproduccion.each do |prod|
#   pelijefedeproduccion = Pelicula.find_by(idcinechile: prod[:pelicula_id])
#   pelijefedeproduccion.jefedeprod = prod[:nombre_personaje]
#   pelijefedeproduccion.save
#   puts "agregando jefedeproduccion #{pelijefedeproduccion.jefedeprod} a #{pelijefedeproduccion.titulo} "
# end
#  jefedeproduccion.each do |jefedeproduccion|
#    da = JefeProduccion.new(peliculaid: jefedeproduccion[:pelicula_id], nombre: jefedeproduccion[:nombre_personaje])
#   da.save!
#   puts "agregando jefedeproduccion #{da.nombre}"
#   end


# # # montaje
# montaje = Array.new
# csv_text_montaje = File.read(Rails.root.join('lib', 'seeds', 'montaje.csv'))
# csvd = CSV.parse(csv_text_montaje, headers: true, header_converters: :symbol, converters: :all, :encoding => 'iso-8859-1:UTF-8')
# csvd.each do |row|
#   montaje  << row.to_h
#  end

#  montaje.each do |prod|
#   pelimontaje = Pelicula.find_by(idcinechile: prod[:pelicula_id])
#   pelimontaje.montaje = prod[:nombre_personaje]
#   pelimontaje.save
#   puts "agregando montaje #{pelimontaje.montaje} a #{pelimontaje.titulo} "
# end

#  montaje.each do |montaje|
#    da = Montaje.new(peliculaid: montaje[:pelicula_id], nombre: montaje[:nombre_personaje])
#   da.save!
#   puts "agregando montaje #{da.nombre}"
#   end



# # # musica
# musica = Array.new
# csv_text_musica = File.read(Rails.root.join('lib', 'seeds', 'musica.csv'))
# csvd = CSV.parse(csv_text_musica, headers: true, header_converters: :symbol, converters: :all, :encoding => 'iso-8859-1:UTF-8')
# csvd.each do |row|
#   musica  << row.to_h
#  end

#  musica.each do |prod|
#   pelimusica = Pelicula.find_by(idcinechile: prod[:pelicula_id])
#   pelimusica.musica = prod[:nombre_personaje]
#   pelimusica.save
#   puts "agregando musica #{pelimusica.musica} a #{pelimusica.titulo} "
# end

#  musica.each do |musica|
#    da = Musica.new(peliculaid: musica[:pelicula_id], nombre: musica[:nombre_personaje])
#   da.save!
#   puts "agregando musica #{da.nombre}"
#   end

# # # maquillaje
# maquillaje = Array.new
# csv_text_maquillaje = File.read(Rails.root.join('lib', 'seeds', 'maquillaje.csv'))
# csvd = CSV.parse(csv_text_maquillaje, headers: true, header_converters: :symbol, converters: :all, :encoding => 'iso-8859-1:UTF-8')
# csvd.each do |row|
#   maquillaje  << row.to_h
#  end

#  maquillaje.each do |prod|
#   pelimaquillaje = Pelicula.find_by(idcinechile: prod[:pelicula_id])
#   pelimaquillaje.maquillaje = prod[:nombre_personaje]
#   pelimaquillaje.save
#   puts "agregando maquillaje #{pelimaquillaje.maquillaje} a #{pelimaquillaje.titulo} "
# end

#  maquillaje.each do |maquillaje|
#    da = Maquillaje.new(peliculaid: maquillaje[:pelicula_id], nombre: maquillaje[:nombre_personaje])
#   da.save!
#   puts "agregando maquillaje #{da.nombre}"
#   end

# # # productora
# productora = Array.new
# csv_text_prod = File.read(Rails.root.join('lib', 'seeds', 'productora.csv'))
# csvd = CSV.parse(csv_text_prod, headers: true, header_converters: :symbol, converters: :all, :encoding => 'ISO-8859-1')
# csvd.each do |row|
#   productora  << row.to_h
#  end

#  productora.each do |prod|
#   peliproductora = Pelicula.find_by(idcinechile: prod[:pelicula_id])
#   peliproductora.productora = prod[:nombre_personaje]
#   peliproductora.save
#   puts "agregando Productora #{peliproductora.productora} a #{peliproductora.titulo} "
# end
# productora.each do |productora|
#    da = Productora.new(peliculaid: productora[:pelicula_id], nombre: productora[:nombre_personaje])
#   da.save!
#   puts "agregando productora #{da.nombre}"
#   end

# # #productorasociado
# productorasociado = Array.new
# csv_text_prod = File.read(Rails.root.join('lib', 'seeds', 'productorasociado.csv'))
# csvd = CSV.parse(csv_text_prod, headers: true, header_converters: :symbol, converters: :all, :encoding => 'ISO-8859-1')
# csvd.each do |row|
#   productorasociado  << row.to_h
#  end

#  productorasociado.each do |prod|
#   peliproductorasociado = Pelicula.find_by(idcinechile: prod[:pelicula_id])
#   peliproductorasociado.productorasociado = prod[:nombre_personaje]
#   peliproductorasociado.save
#   puts "agregando Productorasociado #{peliproductorasociado.productorasociado} a #{peliproductorasociado.titulo} "
# end

# productorasociado.each do |productorasociado|
#    da = Productorasociado.new(peliculaid: productorasociado[:pelicula_id], nombre: productorasociado[:nombre_personaje])
#   da.save!
#   puts "agregando productorasociado #{da.nombre}"
#   end

# # #productorejecutivo
# productorejecutivo = Array.new
# csv_text_prod = File.read(Rails.root.join('lib', 'seeds', 'productorejecutivo.csv'))
# csvd = CSV.parse(csv_text_prod, headers: true, header_converters: :symbol, converters: :all, :encoding => 'ISO-8859-1')
# csvd.each do |row|
#   productorejecutivo  << row.to_h
#  end

#  productorejecutivo.each do |prod|
#   peliproductorejecutivo = Pelicula.find_by(idcinechile: prod[:pelicula_id])
#   peliproductorejecutivo.productorejecutivo = prod[:nombre_personaje]
#   peliproductorejecutivo.save
#   puts "agregando Productorejecutivo #{peliproductorejecutivo.productorejecutivo} a #{peliproductorejecutivo.titulo} "
# end

# productorejecutivo.each do |productorejecutivo|
#    da = Productorejecutivo.new(peliculaid: productorejecutivo[:pelicula_id], nombre: productorejecutivo[:nombre_personaje])
#   da.save!
#   puts "agregando productorejecutivo #{da.nombre}"
#   end

# # # # realizacion
# # realizacion = Array.new
# # csv_text_prod = File.read(Rails.root.join('lib', 'seeds', 'realizacion.csv'))
# # csvd = CSV.parse(csv_text_prod, headers: true, header_converters: :symbol, converters: :all, :encoding => 'ISO-8859-1')
# # csvd.each do |row|
# #   realizacion  << row.to_h
# #  end

# #  realizacion.each do |prod|
# #   pelirealizacion = Pelicula.find_by(idcinechile: prod[:pelicula_id])
# #   pelirealizacion.realizacion = prod[:nombre_personaje]
# #   pelirealizacion.save
# #   puts "agregando realizacion #{pelirealizacion.realizacion} a #{pelirealizacion.titulo} "
# # end

# # realizacion.each do |realizacion|
# #    da = Realizacion.new(peliculaid: realizacion[:pelicula_id], nombre: realizacion[:nombre_personaje])
# #   da.save!
# #   puts "agregando realizacion #{da.nombre}"
# #   end

# # #sonido
# sonido = Array.new
# csv_text_prod = File.read(Rails.root.join('lib', 'seeds', 'sonido.csv'))
# csvd = CSV.parse(csv_text_prod, headers: true, header_converters: :symbol, converters: :all, :encoding => 'ISO-8859-1')
# csvd.each do |row|
#   sonido  << row.to_h
#  end

#  sonido.each do |prod|
#   pelisonido = Pelicula.find_by(idcinechile: prod[:pelicula_id])
#   pelisonido.sonido = prod[:nombre_personaje]
#   pelisonido.save
#   puts "agregando sonido #{pelisonido.sonido} a #{pelisonido.titulo} "
# end

#   sonido.each do |sonido|
#   da = Sonido.new(peliculaid: sonido[:pelicula_id], nombre: sonido[:nombre_personaje])
#   da.save!
#   puts "agregando sonido #{da.nombre}"
#   end


# # #vestuario
# vestuario = Array.new
# csv_text_prod = File.read(Rails.root.join('lib', 'seeds', 'vestuario.csv'))
# csvd = CSV.parse(csv_text_prod, headers: true, header_converters: :symbol, converters: :all, :encoding => 'ISO-8859-1')
# csvd.each do |row|
#   vestuario  << row.to_h
#  end

#  vestuario.each do |prod|
#   pelivestuario = Pelicula.find_by(idcinechile: prod[:pelicula_id])
#   pelivestuario.vestuario = prod[:nombre_personaje]
#   pelivestuario.save
#   puts "agregando vestuario #{pelivestuario.vestuario} a #{pelivestuario.titulo} "
# end

#   vestuario.each do |vestuario|
#   da = Vestuario.new(peliculaid: vestuario[:pelicula_id], nombre: vestuario[:nombre_personaje])
#   da.save!
#   puts "agregando vestuario #{da.nombre}"
#   end

# # #vozenoff
#   vozenoff = Array.new
#   csv_text_prod = File.read(Rails.root.join('lib', 'seeds', 'vozenoff.csv'))
#   csvd = CSV.parse(csv_text_prod, headers: true, header_converters: :symbol, converters: :all, :encoding => 'ISO-8859-1')
#   csvd.each do |row|
#     vozenoff  << row.to_h
#    end

#  vozenoff.each do |prod|
#   pelivozenoff = Pelicula.find_by(idcinechile: prod[:pelicula_id])
#   pelivozenoff.vozenoff = prod[:nombre_personaje]
#   pelivozenoff.save
#   puts "agregando vozenoff #{pelivozenoff.vozenoff} a #{pelivozenoff.titulo} "
# end

#   vozenoff.each do |vozenoff|
#   da = Vozenoff.new(peliculaid: vozenoff[:pelicula_id], nombre: vozenoff[:nombre_personaje])
#   da.save!
#   puts "agregando vozenoff #{da.nombre}"
  # end

