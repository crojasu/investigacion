require 'csv'
require 'json'
require 'open-uri'
require 'i18n'

Pelicula.destroy_all
Rol.destroy_all
Personaje.destroy_all

#total de peliculas
@count=0
sinficha =[]
csv_text = File.read(Rails.root.join('lib', 'seeds', 'pelisdecinechile.csv'))
csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
csv.each do |row|
  tit = I18n.transliterate(row["nombre_pelicula"])
  t = Pelicula.create(idcinechile: row["pelicula_id"], titulo: tit, responsable: row["responsable"], monto: row["monto"], institucion: row["tipo"], contacto: row["contacto"] )
    t.save
    puts "Creando pelicula #{t.titulo} #{t.idcinechile}"

# #matching database from imdb
  imbd  = I18n.transliterate(t.titulo).split.join('+')
  url = "http://www.omdbapi.com/?t=#{imbd}&apikey=e91b7024"
  user_serialized = open(url).read
  value = JSON.parse(user_serialized)
  t.imbd = value
  t.save
  if value["Response"]== "True"
    if value["Director"] != "N/A"
    value["Director"].split(",").each do |dir|
    dire = I18n.transliterate(dir)
    pe = Personaje.create(name: dire)
    da = Rol.create(name: "Direccion")
    da.pelicula = t
    da.personaje = pe
    da.save
     puts "agregando director@s #{da.personaje.name}"
     puts da.id
        end
      end
    if value["Writer"] != "N/A"
    value["Writer"].split(",").each do |gu|
    gui = I18n.transliterate(gu)
    pe2 = Personaje.create(name: gui)
    da2 = Rol.create(name: "Guion")
    da2.pelicula = t
    da2.personaje = pe2
    da2.save
     puts "agregando guion #{da2.personaje.name}"
     puts da2.id
        end
      end
    if value["Actors"] != "N/A"
    value["Actors"].split(",").each do |ac|
      act = I18n.transliterate(ac)
    pe3 = Personaje.create(name: act)
    da3 = Rol.create(name: "Elenco")
    da3.pelicula = t
    da3.personaje = pe3
    da3.save
     puts "agregando elenco #{da3.personaje.name}"
        end
      end
    if value["Production"] != nil && value["Production"] != "N/A"
      value["Production"].split(",").each do |po|
        pro = I18n.transliterate(po)
      pe4 = Personaje.create(name: pro)
      da4 = Rol.create(name: "Casa Productora")
      da4.pelicula = t
      da4.personaje = pe4
      da4.save
       puts "agregando productora #{da4.personaje.name}"
        end
    end
  else
    @count = @count+1
    sinficha << ("#{t.titulo}")
    puts "sin ficha"
  end
  t.save
  end

puts @count
#puts sinficha

 puts "Ahora agregamos las fichas con imbd tt
 ????????????????
 ///////////////"
sinficha2=[]
@count2 =0
imbd = Array.new
csv_text_imbd = File.read(Rails.root.join('lib', 'seeds', 'imdb.csv'))
csvd = CSV.parse(csv_text_imbd, headers: true, header_converters: :symbol, converters: :all, :encoding => 'ISO-8859-1')
csvd.each do |row|
  tit = I18n.transliterate(row[:titulo])
  p2 = Pelicula.find_by_titulo(tit)
  if p2 && row[:im] != nil
  imbd2  = row[:im]
  url2 = "http://www.omdbapi.com/?i=#{imbd2}&apikey=e91b7024"
  user_serialized2 = open(url2).read
  value2 = JSON.parse(user_serialized2)
  p2.imbd = value2
  p2.save
    if value2["Response"]== "True"
    if value2["Director"] != "N/A"
    value2["Director"].split(",").each do |dir|
      dire = I18n.transliterate(dir)
    pe = Personaje.create(name: dire)
    da = Rol.create(name: "Direccion")
    da.pelicula = p2
    da.personaje = pe
    da.save
     puts "agregando director@s #{da.personaje.name}"
        end
      end
    if value2["Writer"] != "N/A"
    value2["Writer"].split(",").each do |gu|
      gui = I18n.transliterate(gu)
    pe2 = Personaje.create(name: gui)
    da2 = Rol.create(name: "Guion")
    da2.pelicula = p2
    da2.personaje = pe2
    da2.save
     puts "agregando guion #{da2.personaje.name}"
        end
      end
    if value2["Actors"] != "N/A"
    value2["Actors"].split(",").each do |ac|
      act = I18n.transliterate(ac)
    pe3 = Personaje.create(name: act)
    da3 = Rol.create(name: "Elenco")
    da3.pelicula = p2
    da3.personaje = pe3
    da3.save
     puts "agregando elenco #{da3.personaje.name}"
        end
      end
    if value2["Production"] != nil && value2["Production"] != "N/A"
      value2["Production"].split(",").each do |po|
        pro = I18n.transliterate(po)
      pe4 = Personaje.create(name: pro)
      da4 = Rol.create(name: "Casa Productora")
      da4.pelicula = p2
      da4.personaje = pe4
      da4.save
       puts "agregando productora #{da4.personaje.name}"
        end
    end
    else
      puts "esto no se que es #{value2["Title"]}"
      puts "#{p2.titulo}"
    end
  else
  @count2 = @count2+1
  puts "la pelicula #{p2.titulo} no se agrego"
  sinficha2 << ("#{p2.titulo}")
  end
 end

puts @directores
puts @count2
puts sinficha2
puts "este es el numero de peliculas sin imbd #{sinficha2.count}"

puts "ahora agregamos director@s /////////////////
////////////////
//////////////
///////////"
# director@s

data= Array.new
csv_text_direc = File.read(Rails.root.join('lib', 'seeds', 'directores.csv'))
csvd = CSV.parse(csv_text_direc, headers: true, header_converters: :symbol, converters: :all, :encoding => 'ISO-8859-1')
csvd.each do |row|
 data << row.to_h
end

@rol= Rol.all
@directors = []
@directors = Rol.where(name: "Direccion")
puts @directors.count

@count1 =0
@existentes = 0
@nuevos = 0
 data.each do |data|
  nombre = I18n.transliterate(data[:nombre_personaje])
  cinechile = Pelicula.find_by(idcinechile: data[:pelicula_id])
  @rol = Rol.where(pelicula_id: cinechile.id)
  @persona = Personaje.where(name: nombre)

  if @rol.any?{|rol| @persona.include? (rol.personaje)}
      puts " #{nombre} ya existe ///////
      //////"
      @existentes = @existentes +1
  else
   puts  "#{nombre} no existe asi que lo agregamos como"
      pe3 = Personaje.create(name: nombre)
      da3 = Rol.create(name: "Direccion")
      da3.pelicula = cinechile
      da3.personaje = pe3
      da3.save
       puts " nuevo director #{da3.personaje.name}/////
       /////"
       pe3.id
       @nuevos =@nuevos + 1
    end
end

puts "directores nuevoc #{@nuevos}"
puts "directores @existentes #{@existentes}"
puts "cantidad directores #{@directors.count}"
puts "cantidad peliculas #{Pelicula.count}"

# # #arte

dataart= Array.new
csv_text_direc = File.read(Rails.root.join('lib', 'seeds', 'arte.csv'))
csvd = CSV.parse(csv_text_direc, headers: true, header_converters: :symbol, converters: :all, :encoding => 'ISO-8859-1')
csvd.each do |row|
  dataart << row.to_h
 end

@artes= []
@artes = Rol.where(name: "Arte")
 dataart.each do |data2|
  nombre2 = I18n.transliterate(data2[:nombre_personaje])
  cinechile2 = Pelicula.find_by(idcinechile: data2[:pelicula_id])
  @rol = Rol.where(pelicula_id: cinechile2.id)
  @personart = Personaje.where(name: nombre2)

   if(@artes.any?{|rol| @personart.include? (rol.personaje)})
        puts " #{nombre2} ya existe ///////
        //////"
    else
     puts  "no existe asi que lo agregamos como"
        pear3 = Personaje.create(name: nombre2)
        daar3 = Rol.create(name: "Arte")
        daar3.pelicula = cinechile2
        daar3.personaje = pear3
        daar3.save
         puts " nuevo arte #{daar3.personaje.name}/////
         /////"
      end
end

puts @artes.count


# #productor
datapro = Array.new
csv_text_prod = File.read(Rails.root.join('lib', 'seeds', 'productor.csv'))
csvd = CSV.parse(csv_text_prod, headers: true, header_converters: :symbol, converters: :all, :encoding => 'ISO-8859-1')
csvd.each do |row|
  datapro  << row.to_h
 end

@productore= []
@productore = Rol.where(name: "Produccion")
 datapro.each do |data3|
  nombre3 = I18n.transliterate(data3[:nombre_personaje])
  cinechile3 = Pelicula.find_by(idcinechile: data3[:pelicula_id])
  @rol = Rol.where(pelicula_id: cinechile3.id)
  @personpro = Personaje.where(name: nombre3)

   if(@productore.any?{|rol| @personpro.include? (rol.personaje)})
        puts " #{nombre3} ya existe ///////
        //////"
    else
     puts  "no existe asi que lo agregamos como"
        pepro = Personaje.create(name: nombre3)
        dapro = Rol.create(name: "Produccion")
        dapro.pelicula = cinechile3
        dapro.personaje = pepro
        dapro.save
         puts " nuevo productor #{dapro.personaje.name}/////
         /////"
      end
end

puts @productore.count

# # asistente de direc
asistentedire = Array.new
csv_text_asdir = File.read(Rails.root.join('lib', 'seeds', 'asistentedire2.csv'))
csvd2 = CSV.parse(csv_text_asdir, headers: true, header_converters: :symbol, converters: :all, :encoding => 'ISO-8859-1')
csvd2.each do |row|
  asistentedire  << row.to_h
 end

@asistente= []
@asistente = Rol.where(name: "Asistente de Direccion")
 asistentedire.each do |data4|
  nombre4 = I18n.transliterate(data4[:nombre_personaje])
  cinechile4 = Pelicula.find_by(idcinechile: data4[:pelicula_id])
  @rol = Rol.where(pelicula_id: cinechile4.id)
  @personasi = Personaje.where(name: nombre4)

   if(@asistente.any?{|rol| @personasi.include? (rol.personaje)})
        puts " #{nombre4} ya existe ///////
        //////"
    else
     puts  "no existe asi que lo agregamos como"
        peasist = Personaje.create(name: nombre4)
        dasist = Rol.create(name: "Asistente de Direccion")
        dasist.pelicula = cinechile4
        dasist.personaje = peasist
        dasist.save
         puts " nuevo asistente de direccions #{dasist.personaje.name}/////
         /////"
      end
end

puts @asistente.count

# #director de foto
direfoto = Array.new
csv_text_direfoto = File.read(Rails.root.join('lib', 'seeds', 'direfoto.csv'))
csvd = CSV.parse(csv_text_direfoto, headers: true, header_converters: :symbol, converters: :all, :encoding => 'iso-8859-1:UTF-8')
csvd.each do |row|
  direfoto  << row.to_h
 end

@direfotos= []
@direfotos = Rol.where(name: "Direccion de Fotografia")
 direfoto.each do |data4|
  nombre4 = I18n.transliterate(data4[:nombre_personaje])
  cinechile4 = Pelicula.find_by(idcinechile: data4[:pelicula_id])
  @rol = Rol.where(pelicula_id: cinechile4.id)
  @personasi = Personaje.where(name: nombre4)

   if(@direfotos.any?{|rol| @personasi.include? (rol.personaje)})
        puts " #{nombre4} ya existe ///////
        //////"
    else
     puts  "no existe asi que lo agregamos como"
        peasist = Personaje.create(name: nombre4)
        dasist = Rol.create(name: "Direccion de Fotografia")
        dasist.pelicula = cinechile4
        dasist.personaje = peasist
        dasist.save
         puts " nuevo direfotos  #{dasist.personaje.name}/////
         /////"
      end
end

puts @direfotos.count

# #efectos
efectosa = Array.new
csv_text_efectos = File.read(Rails.root.join('lib', 'seeds', 'efectosespeciales.csv'))
csvd = CSV.parse(csv_text_efectos, headers: true, header_converters: :symbol, converters: :all, :encoding => 'iso-8859-1:UTF-8')
csvd.each do |row|
  efectosa  << row.to_h
 end

@efectos= []
@efectos = Rol.where(name: "Efectos")
 efectosa.each do |data4|
  nombre4 = I18n.transliterate(data4[:nombre_personaje])
  cinechile4 = Pelicula.find_by(idcinechile: data4[:pelicula_id])
  @rol = Rol.where(pelicula_id: cinechile4.id)
  @personasi = Personaje.where(name: nombre4)

   if(@efectos.any?{|rol| @personasi.include? (rol.personaje)})
        puts " #{nombre4} ya existe ///////
        //////"
    else
     puts  "no existe asi que lo agregamos como"
        peasist = Personaje.create(name: nombre4)
        dasist = Rol.create(name: "Efectos")
        dasist.pelicula = cinechile4
        dasist.personaje = peasist
        dasist.save
         puts " nuevo efectos #{dasist.personaje.name}/////
         /////"
      end
end

puts @efectos.count

# #guion
dataguion = Array.new
csv_text_guion = File.read(Rails.root.join('lib', 'seeds', 'guion.csv'))
csvd = CSV.parse(csv_text_guion, headers: true, header_converters: :symbol, converters: :all, :encoding => 'iso-8859-1:UTF-8')
csvd.each do |row|
  dataguion  << row.to_h
 end

@rol= Rol.all
@guions = []
@guions = Rol.where(name: "Guion")
puts @guions.count

@count1g =0
@existentesg = 0
@nuevosg = 0
 dataguion.each do |data|
  nombre = I18n.transliterate(data[:nombre_personaje])
  cinechile = Pelicula.find_by(idcinechile: data[:pelicula_id])
  @rol = Rol.where(pelicula_id: cinechile.id)
  @persona = Personaje.where(name: nombre)

  if @rol.any?{|rol| @persona.include? (rol.personaje)}
      puts " #{nombre} ya existe ///////
      //////"
      @existentesg = @existentesg +1
  else
   puts  "#{nombre} no existe asi que lo agregamos como"
      pe3 = Personaje.create(name: nombre)
      da3 = Rol.create(name: "Guion")
      da3.pelicula = cinechile
      da3.personaje = pe3
      da3.save
       puts " nuevo guion #{da3.personaje.name}/////
       /////"
       @nuevosg =@nuevosg + 1
    end
end

puts "guiones nuevos #{@nuevosg}"
puts "guiones @existentes #{@existentesg}"
puts "cantidad guiones #{@guions.count}"
puts "cantidad peliculas #{Pelicula.count}"



# # #jefedeproduccion
jefedeproduccion = Array.new
csv_text_jefedeproduccion = File.read(Rails.root.join('lib', 'seeds', 'jefedeproduccion.csv'))
csvd = CSV.parse(csv_text_jefedeproduccion, headers: true, header_converters: :symbol, converters: :all, :encoding => 'iso-8859-1:UTF-8')
csvd.each do |row|
  jefedeproduccion  << row.to_h
 end

 @jefeprod= []
@jefeprod = Rol.where(name: "Jefatura de Produccion")
 jefedeproduccion.each do |data4|
  nombre4 = I18n.transliterate(data4[:nombre_personaje])
  cinechile4 = Pelicula.find_by(idcinechile: data4[:pelicula_id])
  @rol = Rol.where(pelicula_id: cinechile4.id)
  @personasi = Personaje.where(name: nombre4)

   if(@jefeprod.any?{|rol| @personasi.include? (rol.personaje)})
        puts " #{nombre4} ya existe ///////
        //////"
    else
     puts  "no existe asi que lo agregamos como"
        peasist = Personaje.create(name: nombre4)
        dasist = Rol.create(name: "Jefatura de Produccion")
        dasist.pelicula = cinechile4
        dasist.personaje = peasist
        dasist.save
         puts " nuevo jefeprod #{dasist.personaje.name}/////
         /////"
      end
end

puts @jefeprod.count


# # montaje
montaje = Array.new
csv_text_montaje = File.read(Rails.root.join('lib', 'seeds', 'montaje.csv'))
csvd = CSV.parse(csv_text_montaje, headers: true, header_converters: :symbol, converters: :all, :encoding => 'iso-8859-1:UTF-8')
csvd.each do |row|
  montaje  << row.to_h
 end

 @montajes= []
@montajes = Rol.where(name: "Montaje")
 montaje.each do |data4|
  nombre4 = I18n.transliterate(data4[:nombre_personaje])
  cinechile4 = Pelicula.find_by(idcinechile: data4[:pelicula_id])
  @rol = Rol.where(pelicula_id: cinechile4.id)
  @personasi = Personaje.where(name: nombre4)

   if(@montajes.any?{|rol| @personasi.include? (rol.personaje)})
        puts " #{nombre4} ya existe ///////
        //////"
    else
     puts  "no existe asi que lo agregamos como"
        peasist = Personaje.create(name: nombre4)
        dasist = Rol.create(name: "Montaje")
        dasist.pelicula = cinechile4
        dasist.personaje = peasist
        dasist.save
         puts " nuevo montajes #{dasist.personaje.name}/////
         /////"
      end
end

puts @montajes.count

# # musica
musica = Array.new
csv_text_musica = File.read(Rails.root.join('lib', 'seeds', 'musica.csv'))
csvd = CSV.parse(csv_text_musica, headers: true, header_converters: :symbol, converters: :all, :encoding => 'iso-8859-1:UTF-8')
csvd.each do |row|
  musica  << row.to_h
 end

 @musicas= []
@musicas = Rol.where(name: "Musica")
 musica.each do |data4|
  nombre4 = I18n.transliterate(data4[:nombre_personaje])
  cinechile4 = Pelicula.find_by(idcinechile: data4[:pelicula_id])
  @rol = Rol.where(pelicula_id: cinechile4.id)
  @personasi = Personaje.where(name: nombre4)

   if(@musicas.any?{|rol| @personasi.include? (rol.personaje)})
        puts " #{nombre4} ya existe ///////
        //////"
    else
     puts  "no existe asi que lo agregamos como"
        peasist = Personaje.create(name: nombre4)
        dasist = Rol.create(name: "Musica")
        dasist.pelicula = cinechile4
        dasist.personaje = peasist
        dasist.save
         puts " nuevo musicas #{dasist.personaje.name}/////
         /////"
      end
end

puts @musicas.count

# # # maquillaje
maquillaje = Array.new
csv_text_maquillaje = File.read(Rails.root.join('lib', 'seeds', 'maquillaje.csv'))
csvd = CSV.parse(csv_text_maquillaje, headers: true, header_converters: :symbol, converters: :all, :encoding => 'iso-8859-1:UTF-8')
csvd.each do |row|
  maquillaje  << row.to_h
 end


 @maquillajes= []
@maquillajes = Rol.where(name: "Maquillaje")
 maquillaje.each do |data4|
  nombre4 = I18n.transliterate(data4[:nombre_personaje])
  cinechile4 = Pelicula.find_by(idcinechile: data4[:pelicula_id])
  @rol = Rol.where(pelicula_id: cinechile4.id)
  @personasi = Personaje.where(name: nombre4)

   if(@maquillajes.any?{|rol| @personasi.include? (rol.personaje)})
        puts " #{nombre4} ya existe ///////
        //////"
    else
     puts  "no existe asi que lo agregamos como"
        peasist = Personaje.create(name: nombre4)
        dasist = Rol.create(name: "Maquillaje")
        dasist.pelicula = cinechile4
        dasist.personaje = peasist
        dasist.save
         puts " nuevo maquillajes #{dasist.personaje.name}/////
         /////"
      end
end

puts @maquillajes.count

# # productora
productora = Array.new
csv_text_prod = File.read(Rails.root.join('lib', 'seeds', 'productora.csv'))
csvd = CSV.parse(csv_text_prod, headers: true, header_converters: :symbol, converters: :all, :encoding => 'ISO-8859-1')
csvd.each do |row|
  productora  << row.to_h
 end

@rol= Rol.all
@casaproduct = []
@casaproduct = Rol.where(name: "Casa Productora")
puts @casaproduct.count

@count1cp =0
@existentescp = 0
@nuevoscp = 0
 productora.each do |data|
  nombre = I18n.transliterate(data[:nombre_personaje])
  cinechile = Pelicula.find_by(idcinechile: data[:pelicula_id])
  @rol = Rol.where(pelicula_id: cinechile.id)
  @persona = Personaje.where(name: nombre)

  if @rol.any?{|rol| @persona.include? (rol.personaje)}
      puts " #{nombre} ya existe ///////
      //////"
      @existentescp = @existentescp +1
  else
   puts  "#{nombre} no existe asi que lo agregamos como"
      pe3 = Personaje.create(name: nombre)
      da3 = Rol.create(name: "Casa Productora")
      da3.pelicula = cinechile
      da3.personaje = pe3
      da3.save
       puts " nuevo casa productora #{da3.personaje.name}/////
       /////"
       @nuevoscp =@nuevoscp + 1
    end
end

puts "casa productora nuevos #{@nuevoscp}"
puts "casa productora @existentes #{@existentescp}"
puts "cantidad casa productora #{@casaproduct.count}"
puts "cantidad peliculas #{Pelicula.count}"


# #productorasociado
productorasociado = Array.new
csv_text_prod = File.read(Rails.root.join('lib', 'seeds', 'productorasociado.csv'))
csvd = CSV.parse(csv_text_prod, headers: true, header_converters: :symbol, converters: :all, :encoding => 'ISO-8859-1')
csvd.each do |row|
  productorasociado  << row.to_h
 end

 @prodcasoci= []
@prodcasoci = Rol.where(name: "Produccion Asociada")
 productorasociado.each do |data4|
  nombre4 = I18n.transliterate(data4[:nombre_personaje])
  cinechile4 = Pelicula.find_by(idcinechile: data4[:pelicula_id])
  @rol = Rol.where(pelicula_id: cinechile4.id)
  @personasi = Personaje.where(name: nombre4)

   if(@prodcasoci.any?{|rol| @personasi.include? (rol.personaje)})
        puts " #{nombre4} ya existe ///////
        //////"
    else
     puts  "no existe asi que lo agregamos como"
        peasist = Personaje.create(name: nombre4)
        dasist = Rol.create(name: "Produccion Asociada")
        dasist.pelicula = cinechile4
        dasist.personaje = peasist
        dasist.save
         puts " nuevo prodcasoci #{dasist.personaje.name}/////
         /////"
      end
end

puts @prodcasoci.count

# #productorejecutivo
productorejecutivo = Array.new
csv_text_prod = File.read(Rails.root.join('lib', 'seeds', 'productorejecutivo.csv'))
csvd = CSV.parse(csv_text_prod, headers: true, header_converters: :symbol, converters: :all, :encoding => 'ISO-8859-1')
csvd.each do |row|
  productorejecutivo  << row.to_h
 end

 @prodeject= []
@prodeject = Rol.where(name: "Produccion Ejecutiva")
 productorejecutivo.each do |data4|
  nombre4 = I18n.transliterate(data4[:nombre_personaje])
  cinechile4 = Pelicula.find_by(idcinechile: data4[:pelicula_id])
  @rol = Rol.where(pelicula_id: cinechile4.id)
  @personasi = Personaje.where(name: nombre4)

   if(@prodeject.any?{|rol| @personasi.include? (rol.personaje)})
        puts " #{nombre4} ya existe ///////
        //////"
    else
     puts  "no existe asi que lo agregamos como"
        peasist = Personaje.create(name: nombre4)
        dasist = Rol.create(name: "Produccion Ejecutiva")
        dasist.pelicula = cinechile4
        dasist.personaje = peasist
        dasist.save
         puts " nuevo prodeject #{dasist.personaje.name}/////
         /////"
      end
end

puts @prodeject.count

# # # realizacion
realizacion = Array.new
csv_text_prod = File.read(Rails.root.join('lib', 'seeds', 'realizacion2.csv'))
csvd = CSV.parse(csv_text_prod, headers: true, header_converters: :symbol, converters: :all, :encoding => 'ISO-8859-1')
csvd.each do |row|
  realizacion  << row.to_h
 end

 @realizacions= []
@realizacions = Rol.where(name: "Realizacion")
 realizacion.each do |data4|
  nombre4 = I18n.transliterate(data4[:nombre_personaje])
  cinechile4 = Pelicula.find_by(idcinechile: data4[:pelicula_id])
  @rol = Rol.where(pelicula_id: cinechile4.id)
  @personasi = Personaje.where(name: nombre4)

   if(@realizacions.any?{|rol| @personasi.include? (rol.personaje)})
        puts " #{nombre4} ya existe ///////
        //////"
    else
     puts  "no existe asi que lo agregamos como"
        peasist = Personaje.create(name: nombre4)
        dasist = Rol.create(name: "Realizacion")
        dasist.pelicula = cinechile4
        dasist.personaje = peasist
        dasist.save
         puts " nuevo realizacions #{dasist.personaje.name}/////
         /////"
      end
end

puts @realizacions.count

# #sonido
sonido = Array.new
csv_text_prod = File.read(Rails.root.join('lib', 'seeds', 'sonido.csv'))
csvd = CSV.parse(csv_text_prod, headers: true, header_converters: :symbol, converters: :all, :encoding => 'ISO-8859-1')
csvd.each do |row|
  sonido  << row.to_h
 end

 @sonidos= []
@sonidos = Rol.where(name: "Sonido")
 sonido.each do |data4|
  nombre4 = I18n.transliterate(data4[:nombre_personaje])
  cinechile4 = Pelicula.find_by(idcinechile: data4[:pelicula_id])
  @rol = Rol.where(pelicula_id: cinechile4.id)
  @personasi = Personaje.where(name: nombre4)

   if(@sonidos.any?{|rol| @personasi.include? (rol.personaje)})
        puts " #{nombre4} ya existe ///////
        //////"
    else
     puts  "no existe asi que lo agregamos como"
        peasist = Personaje.create(name: nombre4)
        dasist = Rol.create(name: "Sonido")
        dasist.pelicula = cinechile4
        dasist.personaje = peasist
        dasist.save
         puts " nuevo sonidos #{dasist.personaje.name}/////
         /////"
      end
end

puts @sonidos.count

# # #vestuario
vestuario = Array.new
csv_text_prod = File.read(Rails.root.join('lib', 'seeds', 'vestuario.csv'))
csvd = CSV.parse(csv_text_prod, headers: true, header_converters: :symbol, converters: :all, :encoding => 'ISO-8859-1')
csvd.each do |row|
  vestuario  << row.to_h
 end

 @vestuarios= []
@vestuarios = Rol.where(name: "Vestuario")
 vestuario.each do |data4|
  nombre4 = I18n.transliterate(data4[:nombre_personaje])
  cinechile4 = Pelicula.find_by(idcinechile: data4[:pelicula_id])
  @rol = Rol.where(pelicula_id: cinechile4.id)
  @personasi = Personaje.where(name: nombre4)

   if(@vestuarios.any?{|rol| @personasi.include? (rol.personaje)})
        puts " #{nombre4} ya existe ///////
        //////"
    else
     puts  "no existe asi que lo agregamos como"
        peasist = Personaje.create(name: nombre4)
        dasist = Rol.create(name: "Vestuario")
        dasist.pelicula = cinechile4
        dasist.personaje = peasist
        dasist.save
         puts " nuevo vestuarios #{dasist.personaje.name}/////
         /////"
      end
end

puts @vestuarios.count

# # #vozenoff
  vozenoff = Array.new
  csv_text_prod = File.read(Rails.root.join('lib', 'seeds', 'vozenoff.csv'))
  csvd = CSV.parse(csv_text_prod, headers: true, header_converters: :symbol, converters: :all, :encoding => 'ISO-8859-1')
  csvd.each do |row|
    vozenoff  << row.to_h
   end

 @vozenoff= []
@vozenoff = Rol.where(name: "Voz en Off")
 vozenoff.each do |data4|
  nombre4 = I18n.transliterate(data4[:nombre_personaje])
  cinechile4 = Pelicula.find_by(idcinechile: data4[:pelicula_id])
  @rol = Rol.where(pelicula_id: cinechile4.id)
  @personasi = Personaje.where(name: nombre4)

   if(@vozenoff.any?{|rol| @personasi.include? (rol.personaje)})
        puts " #{nombre4} ya existe ///////
        //////"
    else
     puts  "no existe asi que lo agregamos como"
        peasist = Personaje.create(name: nombre4)
        dasist = Rol.create(name: "Voz en Off")
        dasist.pelicula = cinechile4
        dasist.personaje = peasist
        dasist.save
         puts " nuevo vozenoff #{dasist.personaje.name}/////
         /////"
      end
end

puts @vozenoff.count

