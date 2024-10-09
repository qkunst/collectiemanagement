# frozen_string_literal: true

NOT_USED_FIELDS = %w[aatType owner.files, owner.isCDV]

namespace :import do
  desc "Regenerate versions"
  task kunstwacht: :environment do
    category_type_map_stringed = {
      "Sculptuur / plastiek" => "Sculptuur (binnen)",
      "Sculptuur / plastiek (buiten)" => "Sculptuur (buiten)",
      "Overige Kunstvormen" => nil,
      "Wand- en plafondschildering" => "Gebouwgebonden",
      "Schilderij / paneel" => "Schilderkunst",
      "Installaties" => "Sculptuur (binnen)",
      "Foto" => "Fotografie",
      "Interieur vormgeving" => "Vormgeving",
      "Landschapskunst / terrein vormgeving" => "Sculptuur (buiten)",
      "Keramiek" => "Sculptuur (binnen)",
      "Textielkunst" => "Textiel",
      "Grafiek / collage" => "Grafiek",
      "Tekening" => "Uniek werk op papier",
      "Glas kunst  / Glazenierkunst" => "Vormgeving",
      "Reliëf" => "Sculptuur (binnen)",
      "Mozaïek / Intarsia" => "Gebouwgebonden",
      "Lichtkunst" => "Sculptuur (binnen)"
    }
    material_map_stringed = {
      "1. brons  2. film " => {techniques: ["Brons"], medium: []},
      "17e eeuwsw ijsselstenen van 3 verschillende partijen" => {techniques: [], medium: []},
      "18 monitoren" => {techniques: [], medium: []},
      "2 lagen bullseye glas boven laag opaak geel; bevestigd aan aan roestvrijstalen frame" => {techniques: [], medium: []},
      "20 % nylon" => {techniques: ["Nylon"], medium: []},
      "4 camera's" => {techniques: [], medium: []},
      "4 dvd-spelers" => {techniques: [], medium: ["DVD"]},
      "4 lcd-schermen" => {techniques: [], medium: []},
      "5 mm" => {techniques: [], medium: []},
      "6 mm" => {techniques: [], medium: []},
      "80% wol" => {techniques: ["Wol"], medium: []},
      "aandrijfsysteem" => {techniques: [], medium: []},
      "aarde" => {techniques: [], medium: []},
      "aardewerk" => {techniques: ["Aardewerk"], medium: []},
      "achterkant anti-roest verf" => {techniques: [], medium: []},
      "achterzijde voorzien van een witte silicone-coating" => {techniques: [], medium: []},
      "acryl" => {techniques: "Acrylverf", medium: []},
      "acryl doek" => {techniques: "Acrylverf", medium: ["Doek"]},
      "acryl op doek" => {techniques: "Acrylverf", medium: ["Doek"]},
      "acryl op katoen" => {techniques: "Acrylverf", medium: ["Katoen"]},
      "acryl op linnen" => {techniques: "Acrylverf", medium: ["Linnen"]},
      "acryl op muur" => {techniques: "Acrylverf", medium: []},
      "acryl-verf op stucwerk" => {techniques: "Acrylverf", medium: []},
      "acrylaat" => {techniques: [], medium: []},
      "acryldoek." => {techniques: [], medium: []},
      "acrylverf" => {techniques: "Acrylverf", medium: []},
      "acrylverf op doek" => {techniques: "Acrylverf", medium: "Doek"},
      "acrylverf op multiplex" => {techniques: "Acrylverf", medium: "Multiplex"},
      "afgewerkt met grijze ijzerglimmer" => {techniques: [], medium: []},
      "afgewerkt met vernis" => {techniques: [], medium: []},
      "afspeelapparatuur" => {techniques: [], medium: []},
      "afwerking cortenstaal en grind" => {techniques: "Cortenstaal", medium: []},
      "alluminium" => {techniques: "Aluminium", medium: []},
      "alum" => {techniques: "Aluminium", medium: []},
      "aluminium" => {techniques: "Aluminium", medium: []},
      "aluminium bak" => {techniques: "Aluminium", medium: []},
      "aluminium constructie" => {techniques: [], medium: "Aluminium"},
      "aluminium frame" => {techniques: [], medium: [], frame_type: "Aluminium"},
      "aluminium frames" => {techniques: [], medium: [], frame_type: "Aluminium"},
      "aluminium geëtst" => {techniques: ["Ets"], medium: ["Aluminium"]},
      "aluminiumplaat" => {techniques: [], medium: ["Aluminium"]},
      "aluminiumstrips" => {techniques: [], medium: []},
      "aquarel" => {techniques: ["Aquarel"], medium: []},
      "aquarel papier" => {techniques: ["Aquarel"], medium: ["Papier"]},
      "argon" => {techniques: [], medium: []},
      "asfalt" => {techniques: [], medium: []},
      "asfaltbeton" => {techniques: [], medium: []},
      "audio" => {techniques: [], medium: []},
      "australië" => {techniques: [], medium: []},
      "autolak" => {techniques: [], medium: []},
      "baksteen" => {techniques: ["Steen"], medium: []},
      "baksteen autobanden" => {techniques: [], medium: []},
      "bakstenen" => {techniques: [], medium: []},
      "bamboe" => {techniques: [], medium: []},
      "barietpapier" => {techniques: [], medium: ["Papier"]},
      "basalt" => {techniques: [], medium: []},
      "bedrading" => {techniques: [], medium: []},
      "behang; gegalvaniseerd ijzer" => {techniques: [], medium: []},
      "beide: acryl en gouache op katoen" => {techniques: ["Acrylverf", "Gouache"], medium: []},
      "belgisch blauwe hardsteen" => {techniques: [], medium: []},
      "belgisch hardsteen uit de carriere clypot soignies. gekloofd." => {techniques: [], medium: []},
      "beplanting" => {techniques: [], medium: []},
      "bepleisterd polystyreen" => {techniques: [], medium: []},
      "berken" => {techniques: [], medium: []},
      "beschilderd" => {techniques: [], medium: []},
      "beslag" => {techniques: [], medium: []},
      "bestratingsmateriaal" => {techniques: [], medium: []},
      "besturings computer." => {techniques: [], medium: []},
      "betegeld" => {techniques: [], medium: []},
      "beton" => {techniques: ["Beton"], medium: []},
      "beton (sokkel)" => {techniques: [], medium: ["Beton"]},
      "beton baksteen" => {techniques: [], medium: []},
      "beton met kleurtoeslag" => {techniques: ["Beton"], medium: []},
      "beton met natuursteen" => {techniques: ["Beton", "Natuursteen"], medium: []},
      "beton met verschillende toeslagen" => {techniques: ["Beton"], medium: []},
      "beton(sokkel)" => {techniques: [], medium: ["Beton"]},
      "betonnen stoeptegeltjes 10x10x5cm (22.000 stuks" => {techniques: ["Tegel"], medium: []},
      "betonplex" => {techniques: [], medium: []},
      "bevestigingsmateriaal" => {techniques: [], medium: []},
      "biocultuur." => {techniques: [], medium: []},
      "bladgoud" => {techniques: ["Bladgoud"], medium: []},
      "bladgoud, olieverf: vermiljoen, loodwit, pruisisch blauw, napels geel en cochenillerood (scharlaken- of karmozijnrood).; papierbehang" => {techniques: ["Bladgoud", "Olieverf"], medium: ["Papier"]},
      "blauw gelakt" => {techniques: [], medium: []},
      "blauw glas" => {techniques: [], medium: []},
      "blauw. aluminium" => {techniques: [], medium: []},
      "blauwe led lijnen" => {techniques: [], medium: []},
      "blauwe neonlampen" => {techniques: [], medium: []},
      "blockoutdoek met fcframe van 19mm dik" => {techniques: [], medium: []},
      "bloemen" => {techniques: [], medium: []},
      "board" => {techniques: [], medium: ["Board"]},
      "bomen" => {techniques: [], medium: []},
      "boneblack acrylic" => {techniques: [], medium: []},
      "borosilocaat glas" => {techniques: [], medium: []},
      "brons" => {techniques: ["Brons"], medium: []},
      "brons met betonnen sokkel" => {techniques: [], medium: []},
      "brons op granieten voetstuk" => {techniques: [], medium: []},
      "bronzen beeld op sokkel" => {techniques: [], medium: []},
      "buitenmuurverf: alphatex iq mat van sikkens" => {techniques: [], medium: []},
      "camaieu in blauwgroene verf (met hoogsels in goud) aangebrachte voorstellingen  rusten op een ajour (opengewerkt) basement." => {techniques: [], medium: []},
      "canvas" => {techniques: [], medium: ["Canvas"]},
      "caparol" => {techniques: [], medium: []},
      "carbon" => {techniques: ["Carbon"], medium: []},
      "carrara marmer" => {techniques: [], medium: []},
      "caseïneverf op panelen" => {techniques: [], medium: []},
      "cement" => {techniques: ["Cement"], medium: []},
      "chamotte" => {techniques: [], medium: []},
      "cibachrome" => {techniques: [], medium: []},
      "cibachrome print" => {techniques: [], medium: []},
      "coating" => {techniques: [], medium: []},
      "cocoon" => {techniques: [], medium: []},
      "collage" => {techniques: ["Collage"], medium: []},
      "computer" => {techniques: [], medium: ["Computer"]},
      "corten" => {techniques: ["Cortenstaal"], medium: []},
      "corten staal" => {techniques: ["Cortenstaal"], medium: []},
      "cortenstaal" => {techniques: ["Cortenstaal"], medium: []},
      "deels geschilderd" => {techniques: [""], medium: []},
      "den bosch" => {techniques: [], medium: []},
      "dia" => {techniques: [], medium: ["Dia"]},
      "dia's" => {techniques: [], medium: ["Dia"]},
      "diatransfoto's" => {techniques: [], medium: ["Dia"]},
      "dibond" => {techniques: [], medium: ["Dibond"]},
      "dibond en" => {techniques: [], medium: ["Dibond"]},
      "dierengroei" => {techniques: [], medium: []},
      "dik 3mm" => {techniques: [], medium: []},
      "dioriet)" => {techniques: [], medium: []},
      "divers" => {techniques: [], medium: []},
      "diverse" => {techniques: [], medium: []},
      "doek" => {techniques: [], medium: ["Doek"]},
      "doek met aluminium frame" => {techniques: [], medium: ["Doek"], frame_type: "Aluminium"},
      "doek verf metaal" => {techniques: [], medium: ["Doek"]},
      "dolomiet-steen" => {techniques: [], medium: []},
      "doorzichtig polymer" => {techniques: [], medium: []},
      "draad" => {techniques: [], medium: []},
      "drijvend deel gevuld met polystyreen" => {techniques: [], medium: []},
      "druk" => {techniques: [], medium: []},
      "duurzame houtsoort azobé" => {techniques: [], medium: ["Hout"]},
      "eikenhout" => {techniques: [], medium: ["Hout"]},
      "eitempera" => {techniques: ["Ei-tempera"], medium: []},
      "ekta color print" => {techniques: [], medium: []},
      "electrische kabels" => {techniques: [], medium: []},
      "electromotoren" => {techniques: [], medium: []},
      "electronica" => {techniques: [], medium: []},
      "electronica voor de aansturing" => {techniques: [], medium: []},
      "electronica." => {techniques: [], medium: []},
      "elektronica" => {techniques: [], medium: []},
      "elk met de hand gezaagd op 5 cm hoogte)" => {techniques: [], medium: []},
      "ellastiek buizen van koolstofvezel ledlampjes" => {techniques: [], medium: []},
      "emaille" => {techniques: ["Emaille"], medium: []},
      "emaillen" => {techniques: ["Emaille"], medium: []},
      "emulsie" => {techniques: [], medium: []},
      "en ingelijst in aluminium baklijst" => {techniques: [], medium: [], frame_type: "Aluminium"},
      "epoxy hars" => {techniques: ["Epoxy"], medium: []},
      "epoxy)" => {techniques: ["Epoxy"], medium: []},
      "epoxyhars" => {techniques: ["Epoxy"], medium: []},
      "essen hout; beton" => {techniques: [], medium: ["Hout", "Beton"]},
      "etc." => {techniques: [], medium: []},
      "fabriano papier" => {techniques: [], medium: ["Papier"]},
      "film" => {techniques: ["Film"], medium: ["Film"]},
      "flatscreen gluid" => {techniques: [], medium: []},
      "folie" => {techniques: ["Folie"], medium: []},
      "folie met marker" => {techniques: ["Folie"], medium: []},
      "fortrexplaat gelijmd linnen" => {techniques: [], medium: ["Linnen"]},
      "foto" => {techniques: ["Foto"], medium: [""]},
      "foto geplakt op opaalperspex" => {techniques: ["Foto"], medium: ["Perspex"]},
      "foto in diepe  perspex lijst" => {techniques: ["Foto"], medium: ["Perspex"]},
      "foto op fijnmazig linnen" => {techniques: ["Foto"], medium: ["Linnen"]},
      "foto's" => {techniques: ["Foto"], medium: []},
      "foto's ingelijst" => {techniques: ["Foto"], medium: []},
      "foto's op panelen" => {techniques: ["Foto"], medium: ["Paneel"]},
      "foto's op plexiglas" => {techniques: ["Foto"], medium: ["plexiglas"]},
      "fotoafbeeldingen" => {techniques: ["Foto"], medium: []},
      "fotografische print tussen gelamineerd glas" => {techniques: ["Foto"], medium: []},
      "fotopapier" => {techniques: ["Foto"], medium: ["Papier"]},
      "fotoprint" => {techniques: ["Foto"], medium: []},
      "fotoprint op aluminium" => {techniques: ["Foto"], medium: ["Aluminium"]},
      "fotowerk" => {techniques: ["Foto"], medium: []},
      "frame van staal" => {techniques: [], medium: ["Staal"]},
      "frames" => {techniques: [], medium: []},
      "frontfolie" => {techniques: ["Folie"], medium: []},
      "full colour raam folie" => {techniques: ["Folie"], medium: []},
      "gaas" => {techniques: [], medium: []},
      "ge" => {techniques: [], medium: []},
      "geanodiseerd alumi" => {techniques: [], medium: ["Aluminium"]},
      "gebakken" => {techniques: [], medium: []},
      "gebakken draadglas" => {techniques: [], medium: []},
      "gebakken klei" => {techniques: ["Klei"], medium: []},
      "geel" => {techniques: [], medium: []},
      "geen metaal gebruikt. alleen metaal gebruikt voor bedekte sokkel ter bevestiging aan beton." => {techniques: [], medium: []},
      "gefixeerd" => {techniques: [], medium: []},
      "gegalvaniseerd" => {techniques: [], medium: []},
      "geglazuurd" => {techniques: ["Geglazuurd"], medium: []},
      "geglazuurd (majolica)" => {techniques: ["Geglazuurd"], medium: []},
      "geglazuurd keramiek" => {techniques: ["Geglazuurd", "Keramiek"], medium: []},
      "gegoten" => {techniques: [], medium: []},
      "gegoten aluminium" => {techniques: ["Aluminium"], medium: []},
      "gehard glas" => {techniques: [], medium: ["Glas"]},
      "gekleurd folie" => {techniques: ["Folie"], medium: []},
      "gekleurd glas in lood" => {techniques: [], medium: ["Glas"]},
      "gekleurd krijt; latex" => {techniques: ["Latex", "Krijt"], medium: [""]},
      "gekleurd licht" => {techniques: [], medium: []},
      "gekleurde folie" => {techniques: ["Folie"], medium: []},
      "gekleurde lampen" => {techniques: [], medium: []},
      "gekleurde lichtslangen" => {techniques: [], medium: []},
      "gelakt in 2-componentenlak" => {techniques: ["Lak"], medium: []},
      "gelakt." => {techniques: ["Lak"], medium: []},
      "gelamineerde transparante fotoprints." => {techniques: ["Foto"], medium: []},
      "gelast" => {techniques: [], medium: []},
      "gelaste stalen buis 50x50mm" => {techniques: [], medium: []},
      "gemengde techniek op papier" => {techniques: [], medium: []},
      "gemoffeld alumium" => {techniques: ["Aluminium"], medium: []},
      "gemoffeld)" => {techniques: [], medium: []},
      "geoxydeerd" => {techniques: [], medium: []},
      "gepatineerd (holle constructie met stalen balken inwendig verstevigd)" => {techniques: [], medium: []},
      "gepatineerd messing" => {techniques: ["Messing"], medium: []},
      "gepatineerde zinkplaat" => {techniques: ["Zink"], medium: []},
      "geperforeerd stretchmetaal" => {techniques: ["Metaal"], medium: []},
      "geplastificeerd linnen" => {techniques: [], medium: ["Linnen"]},
      "gepolijst" => {techniques: [], medium: []},
      "gepolijst staal (plaatijzer 3 mm dik)" => {techniques: ["Staal"], medium: []},
      "geprint op textiel" => {techniques: ["Print"], medium: ["Textiel"]},
      "geslepen" => {techniques: [], medium: []},
      "geslepen glas van 10" => {techniques: ["Glas"], medium: []},
      "gespoten in acrylaatlak" => {techniques: ["Lak"], medium: []},
      "gesso" => {techniques: [], medium: []},
      "gezandstraald" => {techniques: [], medium: []},
      "gezandstraald glas;" => {techniques: ["Glas"], medium: []},
      "gezet" => {techniques: [], medium: []},
      "gezet in v-vorm" => {techniques: [], medium: []},
      "geëmailleerd staal" => {techniques: ["Staal"], medium: []},
      "gietijzer" => {techniques: ["Gietijzer"], medium: []},
      "gietvloer: epoxy;" => {techniques: ["Epoxy"], medium: []},
      "gips" => {techniques: ["Gips"], medium: []},
      "glas" => {techniques: ["Glas"], medium: []},
      "glas in lood. glas gebrandschilderd. behang." => {techniques: ["Glas"], medium: []},
      "glas in staal" => {techniques: ["Glas"], medium: []},
      "glas metaal led verlichting" => {techniques: ["Glas"], medium: []},
      "glas-in-lood" => {techniques: ["Glas"], medium: []},
      "glas; bedrukte folie" => {techniques: ["Glas"], medium: []},
      "glasgewapend poly" => {techniques: [], medium: []},
      "glasgewapend polyester" => {techniques: [], medium: []},
      "glasplaten" => {techniques: ["Glas"], medium: []},
      "glasschilderkunst" => {techniques: ["Glas"], medium: []},
      "glasvezelkabel" => {techniques: [], medium: []},
      "glazuur" => {techniques: ["Geglazuurd"], medium: []},
      "gordijnstof" => {techniques: ["Textiel"], medium: []},
      "grafiet op gesso ondergrond" => {techniques: ["Grafiet"], medium: []},
      "grafietpoeder" => {techniques: ["Grafiet"], medium: []},
      "graniet" => {techniques: ["Steen"], medium: []},
      "graniet 'african black'" => {techniques: ["Steen"], medium: []},
      "gras" => {techniques: [], medium: []},
      "grind" => {techniques: [], medium: []},
      "grint" => {techniques: [], medium: []},
      "grintvloer" => {techniques: [], medium: []},
      "groen" => {techniques: [], medium: []},
      "groen gepatineerd" => {techniques: ["Gepatineerd"], medium: []},
      "groenvoorziening" => {techniques: [], medium: []},
      "grond" => {techniques: [], medium: []},
      "hamerslagverf" => {techniques: [""], medium: []},
      "hardhout" => {techniques: ["Hout"], medium: []},
      "hardsteen" => {techniques: ["Steen"], medium: []},
      "hechthout" => {techniques: [], medium: []},
      "houder met naambord" => {techniques: [], medium: []},
      "hout" => {techniques: ["Hout"], medium: []},
      "hout glas" => {techniques: ["Hout", "Glas"], medium: []},
      "hout of kunststof" => {techniques: [], medium: []},
      "houten lamellen" => {techniques: [], medium: []},
      "houten lat." => {techniques: [], medium: []},
      "houten lijst" => {techniques: [], medium: [], frame_type: "Hout"},
      "houtskool" => {techniques: ["Houtskool"], medium: []},
      "houtskool op doek" => {techniques: ["Houtskool"], medium: []},
      "houtskool op papier" => {techniques: ["Houtskool"], medium: []},
      "houtskool) op multiplex" => {techniques: ["Houtskool"], medium: []},
      "ijzer" => {techniques: ["IJzer"], medium: []},
      "ijzer." => {techniques: ["IJzer"], medium: []},
      "impala graniet" => {techniques: [], medium: []},
      "ingelijst" => {techniques: [], medium: []},
      "ingelijste foto's" => {techniques: [], medium: []},
      "inkt" => {techniques: ["Inkt"], medium: []},
      "inkt beton kunststof" => {techniques: ["Inkt"], medium: []},
      "inkt op kunststof" => {techniques: ["Inkt"], medium: []},
      "inkt op papier" => {techniques: ["Inkt"], medium: []},
      "inkt." => {techniques: ["Inkt"], medium: []},
      "jacquardweefsel met kunststof" => {techniques: [], medium: []},
      "kabels" => {techniques: [], medium: []},
      "kalk" => {techniques: [], medium: []},
      "karton" => {techniques: [], medium: ["Karton"]},
      "katoen" => {techniques: [], medium: ["Katoen"]},
      "keramiek" => {techniques: ["Keramiek"], medium: []},
      "keramiek (rode klei)" => {techniques: ["Keramiek"], medium: []},
      "keramiek glazuur kunststof" => {techniques: ["Keramiek", "Kunstof", "Geglazuurd"], medium: []},
      "keramische tegels op betonnen binnenwerk" => {techniques: [], medium: []},
      "klei" => {techniques: ["Klei"], medium: []},
      "klei: vingerling k139, gebrand op 1280 graden. engobe: se110 met 1,5 % ijzeroxide (fe o2), gebrand op 1050 graden." => {techniques: ["Klei"], medium: []},
      "kleur folie" => {techniques: ["Folie"], medium: []},
      "kleur lichtgrijs; gelaagd glas gespoten" => {techniques: [], medium: []},
      "kleurenfoto's" => {techniques: [], medium: []},
      "kodak ra-4 printen geplakt op aluminium 1" => {techniques: [], medium: []},
      "koper" => {techniques: ["Koper"], medium: []},
      "koperdraad" => {techniques: ["Koper"], medium: []},
      "koplamp" => {techniques: [], medium: []},
      "koppelstukken katoen in acrylverf" => {techniques: ["Acryl", "Textiel"], medium: []},
      "koudgevormd staal (s235j2)" => {techniques: ["Staal"], medium: []},
      "krijt" => {techniques: ["Krijt"], medium: []},
      "krijt (pastel" => {techniques: ["Krijt"], medium: []},
      "krijt op papier" => {techniques: ["Krijt"], medium: []},
      "krijt verf op paneel" => {techniques: ["Krijtverf"], medium: []},
      "kristal gloeilampen" => {techniques: [], medium: []},
      "kruiden" => {techniques: [], medium: []},
      "kunstof" => {techniques: ["Kunstof"], medium: []},
      "kunststeen: ferrocement" => {techniques: [], medium: []},
      "kunststof" => {techniques: ["Kunstof"], medium: []},
      "kunststof doek" => {techniques: ["Kunstof"], medium: []},
      "kunststof strips" => {techniques: ["Kunstof"], medium: []},
      "kunststofplaat" => {techniques: ["Kunstof"], medium: []},
      "kunstverlichting" => {techniques: [], medium: []},
      "kwik" => {techniques: [], medium: []},
      "lak" => {techniques: ["Lak"], medium: []},
      "lak op doek" => {techniques: ["Lak"], medium: ["Doek"]},
      "lak op papier" => {techniques: ["Lak"], medium: ["Papier"]},
      "lakverf" => {techniques: ["Lak"], medium: []},
      "lamp" => {techniques: [], medium: []},
      "lampen" => {techniques: [], medium: []},
      "lampen: deels led met een enkele kleur en deels rgb led in te stellen." => {techniques: [], medium: []},
      "lampjes" => {techniques: [], medium: []},
      "latex" => {techniques: ["Latex"], medium: []},
      "latex (alfatex)" => {techniques: ["Latex"], medium: []},
      "latex op hout" => {techniques: ["Latex"], medium: ["Hout"]},
      "latexverf op hout" => {techniques: ["Latex"], medium: ["Hout"]},
      "latoenkoper" => {techniques: ["Koper"], medium: []},
      "led lampen in rood" => {techniques: [], medium: []},
      "led licht" => {techniques: [], medium: []},
      "led lichtbank" => {techniques: [], medium: []},
      "led verlichting" => {techniques: [], medium: []},
      "led's" => {techniques: [], medium: []},
      "led-armaturen" => {techniques: [], medium: []},
      "led-licht; aluminium; glaskralen; tigertail; lexaan; metaal." => {techniques: [], medium: []},
      "ledlichtarmaturen" => {techniques: [], medium: []},
      "leds" => {techniques: [], medium: []},
      "leer" => {techniques: [], medium: []},
      "lexaan" => {techniques: [], medium: []},
      "lichtbak" => {techniques: [], medium: []},
      "lichtkast" => {techniques: [], medium: []},
      "lichtkrant" => {techniques: [], medium: []},
      "lichtslangen" => {techniques: [], medium: []},
      "lichtsnoer" => {techniques: [], medium: []},
      "lijst" => {techniques: [], medium: []},
      "lijsten" => {techniques: [], medium: []},
      "linnen" => {techniques: [], medium: ["Linnen"]},
      "linnen garens; klittenband" => {techniques: [], medium: ["Linnen"]},
      "linnen op aluminium panelen op regelwerk" => {techniques: [], medium: ["Aluminium"]},
      "linoleum" => {techniques: ["Linoleum"], medium: []},
      "lood" => {techniques: ["Lood"], medium: []},
      "loodverzwaring" => {techniques: [], medium: []},
      "luchtcompressie" => {techniques: [], medium: []},
      "maansteen" => {techniques: [], medium: []},
      "magneet" => {techniques: [], medium: []},
      "marmer" => {techniques: ["Marmer"], medium: []},
      "marmer (cristallino)" => {techniques: ["Marmer"], medium: []},
      "marmer (vert timos)" => {techniques: ["Marmer"], medium: []},
      "marmoleum" => {techniques: [], medium: []},
      "mdf" => {techniques: [], medium: []},
      "mdf-plaat" => {techniques: [], medium: []},
      "meerdere materialen: organisch materiaal, metaal" => {techniques: ["Metaal"], medium: []},
      "meerkleurige gietvloer" => {techniques: [], medium: []},
      "melkglas" => {techniques: ["Glas"], medium: []},
      "menie" => {techniques: [], medium: []},
      "mercedes motor" => {techniques: [], medium: []},
      "messing" => {techniques: ["Messing"], medium: []},
      "messing lijnen" => {techniques: ["Messing"], medium: []},
      "messing noppen in chinees graniet steen" => {techniques: ["Messing"], medium: []},
      "messingdraad-'weefsel' aan rvs hangstaven" => {techniques: ["Messing"], medium: []},
      "met beschermfolie" => {techniques: [], medium: []},
      "metaal" => {techniques: ["Metaal"], medium: []},
      "metaal (beeld)" => {techniques: ["Metaal"], medium: []},
      "metaal (emaille)" => {techniques: ["Metaal"], medium: []},
      "metaal met kunststof" => {techniques: ["Metaal"], medium: []},
      "metaalvernis" => {techniques: [], medium: []},
      "micro-processor" => {techniques: [], medium: []},
      "monitoren" => {techniques: [], medium: []},
      "multiplex" => {techniques: [], medium: ["Multiplex"]},
      "multiplex 22mm" => {techniques: [], medium: ["Multiplex"]},
      "mural: decotex met zwarte zoom" => {techniques: [], medium: []},
      "muurverf" => {techniques: [], medium: []},
      "natuursteen" => {techniques: [], medium: []},
      "natuursteen (graniet" => {techniques: [], medium: []},
      "natuursteen (graniet vire); 3 blokken" => {techniques: [], medium: []},
      "natuursteen (verde guatemala)" => {techniques: [], medium: []},
      "nederlands eiken" => {techniques: [], medium: []},
      "neon" => {techniques: [], medium: []},
      "neon buizen" => {techniques: [], medium: []},
      "neon." => {techniques: [], medium: []},
      "neonbuizen" => {techniques: [], medium: []},
      "neonverlichting" => {techniques: [], medium: []},
      "netwerk apparatuur" => {techniques: [], medium: []},
      "nieuwe media appararuur" => {techniques: [], medium: []},
      "nikkel op brons" => {techniques: [], medium: []},
      "nylon" => {techniques: [], medium: []},
      "olie" => {techniques: [], medium: []},
      "oliekrijt op papier" => {techniques: [], medium: []},
      "oliepastel" => {techniques: [], medium: []},
      "olieverf" => {techniques: [], medium: []},
      "olieverf  op doek" => {techniques: [], medium: []},
      "olieverf op aluminium" => {techniques: [], medium: []},
      "olieverf op doek" => {techniques: [], medium: []},
      "olieverf op doek op paneel" => {techniques: [], medium: []},
      "olieverf op hout" => {techniques: [], medium: []},
      "olieverf op linnen" => {techniques: [], medium: []},
      "olieverf op linnen op frame" => {techniques: [], medium: []},
      "olieverf op paneel" => {techniques: [], medium: []},
      "onbekend" => {techniques: [], medium: []},
      "ongeglazuurde bakstenen" => {techniques: [], medium: []},
      "op kunsstofplaat (pvc-schuim)" => {techniques: [], medium: []},
      "op papier in lijst" => {techniques: [], medium: []},
      "opgeplakt op aluminium" => {techniques: [], medium: []},
      "ophangprofielen" => {techniques: [], medium: []},
      "oude scheepsplaat" => {techniques: [], medium: []},
      "paneel" => {techniques: [], medium: []},
      "papier" => {techniques: [], medium: []},
      "papier + verf" => {techniques: [], medium: []},
      "papier maché" => {techniques: [], medium: []},
      "papier op linnen" => {techniques: [], medium: []},
      "papier op papier" => {techniques: [], medium: []},
      "pastel" => {techniques: [], medium: []},
      "pastelkrijt" => {techniques: [], medium: []},
      "pen" => {techniques: [], medium: []},
      "perspex" => {techniques: [], medium: []},
      "persplex" => {techniques: [], medium: []},
      "pigment" => {techniques: [], medium: []},
      "piëzografie" => {techniques: [], medium: []},
      "plaatselijk gezandstraald terrament beton" => {techniques: [], medium: []},
      "plaatstaal" => {techniques: [], medium: []},
      "plakfolie" => {techniques: [], medium: []},
      "planten" => {techniques: [], medium: []},
      "planten:sedum en festuca glanca" => {techniques: [], medium: []},
      "plantengroei" => {techniques: [], medium: []},
      "plastic" => {techniques: [], medium: []},
      "pleister" => {techniques: [], medium: []},
      "plexiglas" => {techniques: [], medium: ["Plexiglas"]},
      "plexiglas aluminum u- profiel" => {techniques: [], medium: ["Plexiglas"]},
      "plywood" => {techniques: [], medium: []},
      "polycarbonaat film" => {techniques: [], medium: []},
      "polyester" => {techniques: [], medium: []},
      "polypropyleen" => {techniques: [], medium: []},
      "poolhoogte 8mm" => {techniques: [], medium: []},
      "porcelein" => {techniques: [], medium: []},
      "portugees marmer" => {techniques: [], medium: []},
      "potlood" => {techniques: [], medium: []},
      "potlood op doek" => {techniques: [], medium: []},
      "potlood op papier" => {techniques: [], medium: []},
      "print op papier" => {techniques: [], medium: []},
      "print op perspex" => {techniques: [], medium: []},
      "processor" => {techniques: [], medium: []},
      "programmatuur." => {techniques: [], medium: []},
      "projectorlamp" => {techniques: [], medium: []},
      "pur" => {techniques: [], medium: []},
      "pvc" => {techniques: [], medium: []},
      "rgb leds" => {techniques: [], medium: []},
      "rode" => {techniques: [], medium: []},
      "rode baksteen" => {techniques: [], medium: []},
      "roestkleurig door ijzeroxide-behandeling" => {techniques: [], medium: []},
      "roestrvrijstaal" => {techniques: [], medium: []},
      "roestvrij staal" => {techniques: [], medium: []},
      "roestvrijstaal" => {techniques: [], medium: []},
      "rood glas." => {techniques: [], medium: []},
      "rubber" => {techniques: [], medium: []},
      "rvs" => {techniques: [], medium: []},
      "rvs 304" => {techniques: [], medium: []},
      "rvs staalkabels" => {techniques: [], medium: []},
      "rvs-plaat" => {techniques: [], medium: []},
      "scharnieren" => {techniques: [], medium: []},
      "schelpen" => {techniques: [], medium: []},
      "schijnwerpers" => {techniques: [], medium: []},
      "schilderij achter perspex" => {techniques: [], medium: []},
      "schroeven" => {techniques: [], medium: []},
      "sculptuur" => {techniques: [], medium: []},
      "sensoren" => {techniques: [], medium: []},
      "sierbeton" => {techniques: [], medium: []},
      "sloophout" => {techniques: [], medium: []},
      "smd leds" => {techniques: [], medium: []},
      "soft" => {techniques: [], medium: []},
      "software" => {techniques: [], medium: []},
      "spaanplaat" => {techniques: [], medium: []},
      "specie" => {techniques: [], medium: []},
      "spiegelglas" => {techniques: [], medium: []},
      "spiegelkwaliteit" => {techniques: [], medium: []},
      "sprayverf op papier" => {techniques: [], medium: []},
      "spuitbusverf; hout" => {techniques: [], medium: []},
      "spuitlak" => {techniques: [], medium: []},
      "st eustasius" => {techniques: [], medium: []},
      "staal" => {techniques: [], medium: []},
      "staal (geschopeerd" => {techniques: [], medium: []},
      "staal gelakt" => {techniques: [], medium: []},
      "staal; gegalvaniseerd" => {techniques: [], medium: []},
      "staal;lichtbakken" => {techniques: [], medium: []},
      "staaldraad" => {techniques: [], medium: []},
      "staaldraden" => {techniques: [], medium: []},
      "staalkabels" => {techniques: [], medium: []},
      "staalplaat" => {techniques: [], medium: []},
      "staalprofiel" => {techniques: [], medium: []},
      "staalstrip" => {techniques: [], medium: []},
      "stalen constructiedelen voor montage aan de wand." => {techniques: [], medium: []},
      "stalen frame" => {techniques: [], medium: []},
      "stalen frames." => {techniques: [], medium: []},
      "steadler pigment liners" => {techniques: [], medium: []},
      "steen" => {techniques: [], medium: []},
      "stenen" => {techniques: [], medium: []},
      "stift" => {techniques: [], medium: []},
      "stoeptegels in verschillende kleuren" => {techniques: [], medium: []},
      "stof" => {techniques: [], medium: []},
      "stoffering" => {techniques: [], medium: []},
      "stuc" => {techniques: [], medium: []},
      "stucwerk" => {techniques: [], medium: []},
      "takken" => {techniques: [], medium: []},
      "tapijt" => {techniques: [], medium: []},
      "technische koolstofvezel" => {techniques: [], medium: []},
      "tegels" => {techniques: [], medium: []},
      "tempera" => {techniques: [], medium: []},
      "terracotta klei" => {techniques: [], medium: []},
      "terrazzo" => {techniques: [], medium: []},
      "textiel" => {techniques: [], medium: []},
      "textiel bedrukt" => {techniques: [], medium: []},
      "textiel weven wandkleed" => {techniques: [], medium: []},
      "tl-armatuur" => {techniques: [], medium: []},
      "touw" => {techniques: [], medium: []},
      "translucent polyester" => {techniques: [], medium: []},
      "trespa" => {techniques: [], medium: []},
      "trevira cs" => {techniques: [], medium: []},
      "triplex platen" => {techniques: [], medium: []},
      "tropisch  hardhout" => {techniques: [], medium: []},
      "type 661 prof" => {techniques: [], medium: []},
      "verf" => {techniques: [], medium: []},
      "verf (eitempera) op doek" => {techniques: [], medium: []},
      "verf op beton" => {techniques: [], medium: ["Beton"]},
      "verf op doek" => {techniques: [], medium: ["Doek"]},
      "verf op doek + hout" => {techniques: [], medium: ["Doek", "Hout"]},
      "verf op doek op hout" => {techniques: [], medium: ["Doek", "Hout"]},
      "verf op doek op paneel" => {techniques: [], medium: ["Doek", "Paneel"]},
      "verf op hout" => {techniques: [], medium: ["Hout"]},
      "verf op metaal." => {techniques: [], medium: ["Metaal"]},
      "verf op paneel" => {techniques: [], medium: ["Paneel"]},
      "verf op papier" => {techniques: [], medium: ["Papier"]},
      "vergrote foto's" => {techniques: ["Foto"], medium: []},
      "verkeerspaal" => {techniques: [], medium: []},
      "verlichting" => {techniques: [], medium: []},
      "vernis" => {techniques: ["Vernis"], medium: []},
      "verschillende kwartsietsoorten" => {techniques: [], medium: []},
      "verzinkt staal" => {techniques: ["Staal"], medium: []},
      "video" => {techniques: [], medium: []},
      "videobanden" => {techniques: ["Videoband"], medium: []},
      "videocamera" => {techniques: [], medium: []},
      "vilt" => {techniques: ["Vilt"], medium: []},
      "viltstift" => {techniques: ["Viltstift"], medium: []},
      "vinyl" => {techniques: ["Vinyl"], medium: []},
      "vinyl sticker" => {techniques: ["Vinyl"], medium: []},
      "visuele media;pc's +software" => {techniques: [], medium: []},
      "vloerbedekking" => {techniques: [], medium: []},
      "volbad verzinkt" => {techniques: ["Zink"], medium: []},
      "voorrangsborden" => {techniques: [], medium: []},
      "voorzien van een duplexcoating. plaatwerk rvs304 voorzien van een duplexcoating." => {techniques: [], medium: []},
      "waarschijnlijk." => {techniques: [], medium: []},
      "wall tattoo (lijm" => {techniques: [], medium: []},
      "wandframe" => {techniques: [], medium: []},
      "was" => {techniques: ["Was"], medium: []},
      "water" => {techniques: ["Water"], medium: []},
      "waterverf tekening" => {techniques: ["Waterverf"], medium: []},
      "weefsel" => {techniques: [], medium: []},
      "weerstation" => {techniques: [], medium: []},
      "wit" => {techniques: [], medium: []},
      "wit beschilderd" => {techniques: [], medium: []},
      "wit; neon" => {techniques: [], medium: []},
      "wol" => {techniques: ["Wol"], medium: []},
      "wol ' wools of new zealand'" => {techniques: ["Wol"], medium: []},
      "wollen" => {techniques: ["Wol"], medium: []},
      "zand" => {techniques: ["Zand"], medium: []},
      "zand op doek" => {techniques: ["Zand"], medium: ["Doek"]},
      "zand tegels" => {techniques: ["Tegel"], medium: []},
      "zeefdrukinkt" => {techniques: ["Zeefdruk"], medium: []},
      "zilveren" => {techniques: [], medium: []},
      "zilverpoeder" => {techniques: [], medium: []},
      "zilverpotlood." => {techniques: [], medium: []},
      "zink" => {techniques: ["Zink"], medium: []},
      "zonnenpanelenfolie" => {techniques: [], medium: []},
      "zwart kalksteen" => {techniques: ["Steen"], medium: []},
      "zwart vilt" => {techniques: ["Vilt"], medium: []},
      "zwarte inkt op barietpapier" => {techniques: ["Inkt"], medium: ["Papier"]},
      "zwarte tape" => {techniques: [], medium: []},
      "zwarte viltpen" => {techniques: ["Viltpen"], medium: []}
    }

    p material_map_stringed.map { |_, v| v.map { |k, __| k } }.flatten.uniq
    material_submapping = {techniques: Technique, medium: Medium, frame_type: FrameType}
    category_type_map = category_type_map_stringed.map { |k, v| [k, ObjectCategory.find_by_name(v)] }.to_h
    material_map = material_map_stringed.map { |k, v| [k, v.map { |t, m| [t, material_submapping[t].find_by_name(m)] }.to_h] }.to_h

    collection = Collection.find_or_create_by(name: "CIS Rijk")
    json = JSON.parse(File.read(Rails.root.join("data/import/cisrijk.json")))

    # binding.irb

    json.each do |json_work|
      print "🆕"
      w = Work.find_or_initialize_by(stock_number: json_work["inventoryNumber"], collection: collection)
      w.stock_number = json_work.delete("inventoryNumber")
      w.alt_number_1 = json_work.delete("rvbNumber")
      print w.stock_number
      # location
      json_location = json_work.delete("location")
      object_placement = :binnen
      if json_location
        object_placement = :buiten if json_location["placement"] == "buiten"
        json_location.delete_if { |k, v| v.blank? }
        buildingName = json_location["buildingName"]&.strip
        name = if buildingName
          city = json_location["city"]&.strip
          if city.present?
            buildingName + " (#{city})"
          else
            buildingName
          end
        else
          json_location["address"]&.strip
        end

        location = if json_location["buildingNumber"]&.strip.present?
            collection.locations.order(:id).find_or_initialize_by(building_number: json_location["buildingNumber"]&.strip)
          else
            collection.locations.order(:id).find_or_initialize_by(name: name)
          end
        location.name = name
        location.lat = json_location["gpsLatitude"].to_f
        location.lon = json_location["gpsLongitude"].to_f
        location.other_structured_data = json_location.select{|k,v| %w[architects part].include?(k)}
        location.address = json_location["address"]
        location.save
        w.main_location = location
        w.location_detail = [json_location["roomName"], json_location["roomNumber"]].compact.join(" ")
      end
      if json_location.nil?
        json_work["locatie"] = "Geen locatie gegevens"
      end

      print "📍"

      # artists
      w.artists = json_work.delete("artists").map do |artist_json|
        artist_json.delete_if { |k, v| v.blank? }

        artist = Artist.find_by(rkd_artist_id: artist_json["RKDartistID"]) if artist_json["RKDartistID"].present?
        unless artist
          artist = if artist_json["RKDartistID"].present?
            Artist.new(rkd_artist_id: artist_json["RKDartistID"])
          else
            Artist.find_or_initialize_by(first_name: artist_json["firstName"], last_name: artist_json["surName"])
          end
          artist.first_name = artist_json["firstName"]
          artist.last_name = artist_json["surName"]
          artist.prefix = artist_json["interjection"]
          artist.year_of_birth = artist_json["yearOfBirth"]
          artist.year_of_death = artist_json["yearOfDeath"]
          artist.place_of_birth = artist_json["placeOfBirth"]
          artist.place_of_death = artist_json["placeOfDeath"]
          artist.save
        end
        artist
      end

      print "🧑‍🎨"

      w.title = json_work.delete("title")
      w.publish = json_work.delete("showPublic")
      w.description = json_work.delete("description")
      w.object_categories = [category_type_map[json_work["type"]]].compact
      w.object_categories = [ObjectCategory.find_by_name("Sculptuur (buiten)")] if w.object_categories.pluck(:id) == ObjectCategory.where(name: "Sculptuur (binnen)").pluck(:id) && object_placement == :buiten
# binding.irb
      materials = ([json_work.delete("materials")] + [json_work.delete("aatMaterials")]).flatten.compact.uniq
      json_work["materials"] = materials
      material_values = materials.map { |material| material_map[material] }.compact
      w.medium = material_values.flat_map { |material| material[:medium] }.compact.first
      w.frame_type = material_values.flat_map { |material| material[:frame_type] }.compact.first
      w.techniques = material_values.flat_map { |material| material[:techniques] }.compact
      w.object_creation_year = json_work.delete("completionYear") || json_work["startYear"]
      w.internal_comments = json_work.delete("remark")
      w.permanently_fixed = json_work.delete("fixed")
      w.tag_list << json_work.delete("appreciation") if json_work["appreciation"].present?
      w.tag_list << json_work.delete("artHistoric") if json_work["artHistoric"].present?

      # hdw updated to how generally used in collectionmanagment
      w.height = json_work.delete("length")&.to_f&./(10.0)
      w.depth = json_work.delete("height")&.to_f&./(10.0)
      w.width = json_work.delete("width")&.to_f&./(10.0)
      w.diameter = json_work.delete("diameter")&.to_f&./(10.0)
      w.weight = json_work.delete("weight")&.to_f
      w.dimension_weight_description = [json_work.delete("dimensionDescription"), json_work.delete("weightDescription")].compact.join("; ")
      w.print = [json_work.delete("editionNumber"), json_work.delete("editionAmount")].compact.join("/")

      json_work["maintainer"] = json_work.delete("maintainer")&.[]("name")

      owner = json_work.delete("owner")
      if owner.present?
        w.owner = Owner.find_or_create_by(name: owner["name"])
        w.tag_list << "eigenaar-#{owner.dig("method", "identifier")}" if owner.dig("method", "identifier")
        w.purchase_price = owner["cost"].to_f if owner["cost"].present?
        w.purchase_price_currency = Currency.find_by_iso_4217_code(owner.dig("currency", "abbreviation")) if owner.dig("currency", "abbreviation").present?
      end

      print "💶"

      json_work["files"] = json_work.delete("files").map do |file|
        {name: file["name"], downloadUrl: file["url"], description: file["description"]}
      end

      images = json_work.delete("images")

      images = images.values if images.is_a?(Hash)
      images = images.sort_by { |img| img["sortOrder"].to_i }

      w.remote_photo_front_url = images[0]["urlLargeImage"] if images.present? && !w.photo_front.present?
      w.remote_photo_detail_1_url = images[1]["urlLargeImage"] if images[1].present? && !w.photo_detail_1.present?
      w.remote_photo_detail_2_url = images[2]["urlLargeImage"] if images[2].present? && !w.photo_detail_2.present?

      puts images[0]["urlLargeImage"] if images.present?
      json_work["plaatsing"] = object_placement
      json_work["images"] = images.collect { |img| {imageUrl: img["urlLargeImage"], description: img["description"], copyright: img["copyrightDescription"]} }
      print "📷"

      w.old_data = {cisrijk: json_work}
      w.save
      puts "✔︎"
    end
  end
end
