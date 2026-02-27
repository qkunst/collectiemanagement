# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

first_names = ["Henk", "Jan", "Marie", "Janette"]
last_names = ["Schepper", "Maker", "Createur"]

if Rails.env.gitlabci? || Rails.env.test?
  require "sidekiq/testing"
  Sidekiq::Testing.inline!
end

10.times do
  Artist.create(first_name: first_names.sample, last_name: last_names.sample)
end

logistical_peculiarities = ["Heel zwaar", "Ophangsysteem"]
logistical_peculiarities.each { |name| LogisticalPeculiarity.where({name: name}).first_or_create }

object_categories = ["Audiovisueel", "Fotografie", "Gebouwgebonden", "Grafiek", "Schilderkunst", "Sculptuur (binnen)", "Sculptuur (buiten)", "Textiel", "Uniek werk op papier", "Vormgeving"]
object_categories = object_categories.map { |name| ObjectCategory.where({name: name}).first_or_create }

techniques = "3D print,Acrylpapier,Acrylverf,Airbrush,Alblast,Alkydverf,Aluminium,Aquagravure,Aquarel,Aquarelpotlood,Aquatint,Assemblage,Bakeliet,Barietdruk,Batik,Been,Behang,Ben-Day dots print,Beschilderd,Beton,Bijenwas,Biljartbal(len),Blad(eren),Bladgoud,Bladzilver,Blik,Blinddruk,Boardsnede,Boek(en),Bont,Bord(en),Borduurwerk,Bot(ten),Branddruk,Brons,C-print,Carborundumdruk,Chine collé,Cibachrome,Collage,Combiprint,Conté,Cortenstaal,Cortenstaal,DVD,Design,Diamant,Diepdruk,Digitale animatie,Digitale print,Draad,Droge naald,Druk,Drukpers,Ecoline,Ei-tempera,Emaille,Encaustiek,Epoxy,Eta-verf,Ets,Facsimile,Fiberglass,Film,Fineer,Flock,Folie,Fosforprent,Fossiel,Foto,Fotofolie,Fotogram,Fotomontage,Foxing,Frottage,Geglazuurd,Gegraveerd,Gelatine zilverdruk,Gemengde techniek,Gepatineerd,Gesso,Gevlochten,Gewassen,Geweven,Giclée,Giethars,Gietijzer,Gips,Glansdruk,Glas,Glas in lood,Glas-appliqué,Glasplaat,Glasvezel,Gomdruk,Gouache,Goud,Goudblad,Goudverf,Grafiet,Grafiet,Granaat,Graniet,Gravure,Gum,Haar,Handdruk,Handgeblazen,Handgekleurd,Handgemodelleerd,Hars,Hoogdruk,Hout,Houtgravure,Houtpulp,Houtskool,Houtsnede,Houtvuller,IJzer,IJzerdraad,IJzerglimmerverf,Inkt,Inktjetprint,Installatie,Japans marmeren,Jesmoniet,Karton,Keramiek,Kiezelstenen,Kinetisch,Klei,Kleurenfoto,Kleurpotlood,Klok,Kobalt,Kompas,Koper,Koperpoeder,Koraal,Kralen,Krant(en),Krassen,Krijt,Kristal,Kunststof,Kunststof (deze niet gebruiken),Kurk,Kwarts,LED,Lak,Lakverf,Lamdaprint,Lamp(en),Latex,Leer,Leisteen,Lichtbox,Lijm,Linoleum,Linoleumsnede,Lint,Lithografie,Lood,Marmer,Marmerpoeder,Medium,Messing,Metaal,Metaalfolie,Modelleerpasta,Monoprint,Monotype,Mozaïek,Natuursteen,Neon,Neonbuis,Nepbont,Object,Offsetdruk,Oliekrijt,Olieverf,Oost-Indische,Paint stick,Papier,Papier maché,Papiergeld,Papierpulp,Parel(s),Pastel,Pen,Permacryl,Perspex,Piepschuim,Pigment,Piëzografie,Piëzografie (deze niet gebruiken),Plakkaatverf,Plamuur,Plastic,Plastiek,Polaroid,Polyester,Polystyreen,Porselein,Poster,Potlood,Prent,Print,RVS,Readymade,Reliëf,Reproductie,Riet,Rietpen,Risoprint,Rubber,Schelp(en),Schildpad,Schuimrubber,Sepia,Serigrafie,Sgraffito,Silkscreen,Sjabloondruk,Smeedijzer,Spiegel,Spray-paint,Sproeidruk,Sproeidruk,Staal,Steen,Stempel,Stift,Suikerprocedé,Tape,Tapijt,Tarwe,Teer,Tegel,Tegeltableau,Tekening,Tempera,Textiel,Theezakje(s),Tin,Touw,Transfertechniek,Triplex,Uitsnede,Verbronsd,Veren,Verguld,Vernis,Vernis mou,Videoband,Vilt,Vingerafdruk,Wandkleed,Wandobject,Wandplastiek,Wandschildering,Wasco,Water,Waterverf,Wol,Zand,Zeefdruk,Zeepsteen,Zegellak,Zilver,Zilverblad,Zilverdruk,Zink,Zwart-witfoto".split(",")
techniques = techniques.map { |name| Technique.where({name: name}).first_or_create }

media = ["Aluminium", "Baksteen", "Bamboe", "Beton", "Board", "Canvas", "DVD", "Diasec", "Dibond", "Doek", "Foam", "Fotopapier", "Glas", "Graniet", "Hout", "Jute", "Karton", "Katoen", "Krantenpapier", "Kunststof", "Linnen", "Marmer", "Marouflé", "Metaal", "Niet van toepassing", "Paneel", "Papier", "Perspex", "Steen", "Textiel", "Triplex", "Vlieseline"]
media.each { |name| Medium.where({name: name}).first_or_create }

conditions = ["Goed (++)", "Redelijk/Voldoende (+)", "Matig (-)", "Slecht (--)"]
conditions.each_with_index { |name, index| Condition.where({name: name, order: index}).first_or_create }
conditions = Condition.order(:order).all

damage_types = ["Buts(en)", "Craquelé", "Kreukel(s)", "Scheur(en)", "Schimmel", "Verfschade", "Vergeling", "Vocht", "Vouw(en)", "Vuil", "Waas", "Winkelha(a)k(en)", "Zilvervisje(s)"]
damage_types = damage_types.map { |name| DamageType.where({name: name}).first_or_create }

frame_damage_types = ["Buts(en)", "Glasbreuk", "Kras(sen)", "Schimmel", "Verfverlies", "Vermissing glas", "Vermissing lat", "Vocht", "Vuil", "Wijkende hoek(en)"]
frame_damage_types = frame_damage_types.map { |name| FrameDamageType.where({name: name}).first_or_create }

frame_types = ["Aluminium", "Aluminium (donker)grijs", "Aluminium blauw", "Aluminium brons", "Aluminium goud", "Aluminium groen", "Aluminium paars", "Aluminium paars/blauw", "Aluminium rood", "Aluminium wit", "Aluminium zwart", "Baklijst", "Hout", "Hout blauw", "Hout geel", "Hout goud", "Hout grijs", "Hout groen", "Hout paars", "Hout rood", "Hout whitewash", "Hout wit", "Hout zilver", "Hout zwart", "Kunststof", "Metaal", "Multiplex", "Staal"]
frame_types = frame_types.map { |name| FrameType.where({name: name}).first_or_create }

sources = ["BKR", "Schenking", "Relatiegeschenk", "Bruikleen", "Aankoop", "Opdracht"]
sources.each { |name| Source.where({name: name}).first_or_create }

styles = ["Art Nouveau", "Cobra", "Conceptueel/formeel", "Documentair", "Expressionistisch", "Formeel", "Fotorealistisch", "Geometrisch", "Impressionistisch", "Kubistisch", "Minimalistisch", "Overig", "Realistisch", "Surrealistisch", "Traditioneel/klassiek"]
styles = styles.map { |name| Style.where({name: name}).first_or_create }

themes = ["Dier", "Interieur", "Landschap", "Mens", "Muziek", "Sport", "Stedelijk landschap", "Stilleven"]
themes = themes.map { |name| Theme.where({name: name}).first_or_create }

subsets = ["Cartografie en prenten", "Cultuurhistorische collectie", "Documentatie", "Geen kunst", "Hedendaagse kunst", "Moderne kunst", "Outsider art", "Poster", "Replica", "Toegepaste kunst", "Vroegmoderne kunst"]
subsets = subsets.map { |name| Subset.where({name: name}).first_or_create }

placeabilities = ["Contacteer kunstenaar", "Direct inzetbaar", "Naar fotograaf", "Naar lijstenmaker", "Restauratie nodig", "Schoonmaken nodig", "Total loss"]
placeabilities.each_with_index { |name, index| Placeability.where({name: name, order: index}).first_or_create }

currencies = [["EUR", "€", 1], ["USD", "$", 0.86], ["NLG", "𝑓", 2.20371]]
currencies = currencies.map {
  c = Currency.where({iso_4217_code: it[0], hide: false}).first_or_create
  c.update(symbol: it[1], exchange_rate: it[2], name: it[1])
  c
}

collections = ["Demo Collectie A", "Demo Collectie B", "Subcollectie", "Demo Collectie C"]
collections.each { |name| Collection.where({name: name}).first_or_create }

Collection.find_by(name: "Subcollectie").update_column(:parent_collection_id, Collection.find_by(name: "Demo Collectie A").id)

200.times do |time|
  purchase_year = (2000..2021).to_a.sample
  multiplier = (10..100).to_a.sample
  width = (1..4).to_a.sample * multiplier
  height = (1..4).to_a.sample * multiplier
  object_category = object_categories.sample
  frame_width = object_category.name.starts_with?("Sculptuur") ? 0 : [0, 2, 5].sample
  depth = object_category.name.starts_with?("Sculptuur") ? [10, 20, width].sample : [1, 1, 1, nil, nil, nil, 2, 2, 2, 2, 4, 5].sample
  diameter = object_category.name.starts_with?("Sculptuur") ? [width, width + 10].sample : nil
  purchase_price_currency = (purchase_year >= 2002) ? currencies.first : currencies.last
  condition_work = conditions.sample
  condition_frame = (frame_width > 0) ? conditions.sample : nil
  w_damage_types = damage_types.sample(conditions.index(condition_work))
  w_frame_damage_types = (frame_width > 0) ? frame_damage_types.sample(conditions.index(condition_frame)) : []

  parameters = {title: "Werk #{time}",
                artists: [Artist.all.sample],
                stock_number: "AUTO#{time}",
                collection_id: Collection.all.pluck(:id).sample,
                location: ["Depot 1", "Vestiging A"].sample,
                location_floor: [0, 1, 2, 3].sample,
                location_detail: ["A", "B", "C"].sample,
                purchase_year:,
                purchase_price: (400..50000).to_a.sample,
                purchase_price_currency:,
                width:,
                height:,
                depth:,
                diameter:,
                condition_work:,
                condition_frame:,
                damage_types: w_damage_types,
                frame_damage_types: w_frame_damage_types,
                frame_depth: depth,
                frame_width: width + frame_width,
                frame_height: height + frame_width,
                frame_type: (frame_types.sample if frame_width > 0),
                frame_diameter: diameter,
                object_categories: [object_category],
                techniques: techniques.sample([1, 2].sample),
                grade_within_collection: %w[A B C D E F].sample,
                style: styles.sample,
                subset: subsets.sample,
                themes: themes.sample([1, 2].sample)}

  Work.create(parameters)
end

Collection.unscoped.insert({root: true, name: "-", created_at: Time.current, updated_at: Time.current})

c = Collection.unscoped.where(root: true).first

Collection.unscoped.where(parent_collection_id: nil).where.not(root: true).update_all(parent_collection_id: c.id)
