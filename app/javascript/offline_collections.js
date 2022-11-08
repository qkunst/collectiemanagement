const trySettingCollectionsForOfflineUsage = function() {
  const collectionList = document.getElementById("collections-list")
  if (collectionList && collectionList.dataset.collections) {
    localStorage.setItem('collections', collectionList.dataset.collections);
  }
}

const fixOfflineSubmitUrl = function() {
  if (document.querySelector('[data-offline=true]')) {
    var url = document.location.toString();
    var path = url.split("//")[1].split("/").slice(1,1000).join("/");
    var collectionId = path.match(/collections\/(\d+)/i);
    collectionId = collectionId ? collectionId[1] : null;

    document.querySelector('form[action="/collections/-1/works"]').action = "/collections/"+collectionId+"/works";
  }
}

const fillCollectionShowPage = function() {
  if (document.getElementById('collection.name') && document.getElementById('offline')) {
    var url = document.location.toString();
    var protocol = url.split("//")[0];
    var host = url.split("//")[1].split("/")[0];
    var path = url.split("//")[1].split("/").slice(1,1000).join("/");
    var collectionId = path.match(/collections\/(\d+)/i);
    collectionId = collectionId ? collectionId[1] : null;
    var workId = path.match(/works\/([\da-z]+)/i);
    workId = workId ? workId[1] : null;
    var collections = JSON.parse(localStorage.getItem('collections'));
    var collection = collections.filter(function(a){ return a["id"] == collectionId } )[0];

    document.getElementById('collection.name').innerText = collection.name;
    var newWorkButton = document.getElementById('button.add_work');
    newWorkButton.href = "/collections/"+collectionId+"/works/new";

    var offline_stored_count = (FormStore.Store.count_by_key_start(protocol+"//"+host+"/collections/"+collectionId+"/works/new"));
    if (offline_stored_count > 0) {
      $('#offline').css({display: 'block'}).text("Er zijn "+offline_stored_count+" werk(en) nog niet gesynchroniseerd met de server, zodra de server terug online is worden deze opnieuw geprobeerd");
    } else {
    }
  }
}

window.addEventListener("load", function() {
  fixOfflineSubmitUrl();
  trySettingCollectionsForOfflineUsage();
  fillCollectionShowPage();
  return true;
});

document.addEventListener("turbo:load", function() {
  fixOfflineSubmitUrl();
  trySettingCollectionsForOfflineUsage();
  fillCollectionShowPage();
  return true;
});
