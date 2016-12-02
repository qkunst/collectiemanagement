function goToLocation() {
  var host = document.location.host;
  var protocol = document.location.protocol;
  var base = protocol+"//"+host+"/";
  var COLLECTIONS = "collections";
  var WORKS = "works";
  document.location = base+COLLECTIONS+"/1/"+WORKS+"/new";
};
function sleepFor( sleepDuration ){
    var now = new Date().getTime();
    while(new Date().getTime() < now + sleepDuration){ /* do nothing */ }
};
function fillForm() {
  $("#work_location").val("OFFLINECHROME");
  $("#vervaardigers .add_nested_fields").click();
  // sleepFor(1000);
  $($("#vervaardigers input")[5]).val("Maarten");
  $($("#vervaardigers input")[7]).val("Test 1");
  $("#work_title").val("Kunstwerk test");
  $("#work_description").val("Elke definitie van kunst is cultuurspecifiek en tijdgebonden. Van vrijwel elke cultuur zijn voorwerpen bekend die zich onderscheiden van ‘gewone’ objecten doordat er in het algemeen een hogere esthetische waarde aan wordt toegeschreven. Dergelijke objecten hebben soms niet-esthetische - ceremoniële of religieuze of propagandistische - functies, en soms niet. Ook binnen eenzelfde cultuur kunnen opvattingen over kunst evolueren: er ontstaan nieuwe genres en er ontwikkelen zich andere kunstvormen, waardoor het idee over de functie en de aard van kunst verandert Traditionele definities van kunst zijn gebaseerd op een bepaalde eigenschap van het kunstwerk, op de representatieve, expressieve, en de formele eigenschappen. Er zijn dus representatieve of mimetische definities, expressieve definities en formalistische definities, die stellen dat kunstwerken worden gekenmerkt door hun figuratieve, expressieve en formele eigenschappen. Een van de oudste ons overgeleverde beschouwingen over kunst is die van Plato, die in de Staat het kunstwerk typeert als mimetisch, ‘slechts’ een nabootsing van de werkelijkheid (en dus inferieur). De 18e-eeuwse verlichtingsfilosoof Immanuel Kant definieert in zijn Kritik der Urteilskraft (1790) een kunstwerk als 'een soort voorstelling die een doel op zich is, maar niettemin de mentale vermogens voor gezellige communicatie bevordert.' Ook andere invloedrijke filosofen zoals Arthur Schopenhauer en Friedrich Nietzsche hebben zich beziggehouden met kunstbeschouwing - zie daarvoor het artikel esthetica. Conventionalistische definities kwamen onder druk door de opkomst, in de twintigste eeuw, van kunstwerken die sterk afweken van alle voorgaande kunstwerken. Avant-garde werken zoals de 'Fontein' van Marcel Duchamp (een industrieel vervaardigd urinoir dat Duchamp in 1917 onder een pseudoniem signeerde en instuurde voor deelname aan een expositie van de Society of Independent Artists in New York) en andere \"ready-mades\" onttrokken zich aan elke traditionele definitie van kunst. Hetzelfde kan gezegd worden van andere conceptuele werken zoals All the things I know but of which I am not at the moment thinking - 1:36 PM; June 15, 1969 van Robert Barry en 4\" 33 van John Cage. Het scepticisme over de mogelijkheid en de waarde van een definitie van kunst leidde sinds de jaren 1950 tot een discussie binnen de esthetiek die nog steeds gaande is.");
  $("#work_technique_ids").val([10,2,3]).trigger('chosen:updated');
  $("#work_height").val(10.9);
  $("#work_width").val(10.9);
  $("#work_depth").val(10.9);
  $("#work_diameter").val(10.9);
}
function submitForm() {

  $(".form-actions .button").click();

}
$(function() {
  loc = document.location.toString();
  if (loc.match(/1\/works\/new\?test/)) {
    fillForm();
    submitForm();
  }

})