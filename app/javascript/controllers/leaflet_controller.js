import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="leaflet"
export default class extends Controller {
  static targets = ["placeholder"]

  connect() {
    import("leaflet").then(L => {
      console.error("leaflet loaded");
      this.map = L.map(this.placeholderTarget).setView(this._coordinates(), (this.data.get("zoom") || 13));

      var Stamen_TonerLite = L.tileLayer('https://stamen-tiles-{s}.a.ssl.fastly.net/toner-lite/{z}/{x}/{y}{r}.{ext}', {
        attribution: 'Map tiles by <a href="http://stamen.com">Stamen Design</a>, <a href="http://creativecommons.org/licenses/by/3.0">CC BY 3.0</a> &mdash; Map data &copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
        subdomains: 'abcd',
        minZoom: 0,
        maxZoom: 20,
        ext: 'png'
      });
      Stamen_TonerLite.addTo(this.map);

      this._points().forEach((point) => {
        L.circleMarker(point, {
          fillColor: '#007e2b',
          fillOpacity: 0.3,
          radius: 10,
          stroke: false
        }).addTo(this.map);
      })
    });
  }

  disconnect() {
    this.map.remove()
  }

  _coordinates() {
    return [this.data.get("latitude"), this.data.get("longitude")]
  }

  _points() {
    return JSON.parse(this.data.get("points"))
  }
}
