import { Controller } from "stimulus"
import mapboxgl from 'mapbox-gl';
export default class extends Controller {
  static targets = ["mapdiv"]

  connect() {
    this.displayMap()
  }

  fitMapToMarkers(map, markers) {
    const bounds = new mapboxgl.LngLatBounds();
    markers.forEach(marker => bounds.extend([ marker.lng, marker.lat ]));
    map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: 0 });
  };

  displayMap() {
    const mapElement = this.mapdivTarget
    const markers = JSON.parse(mapElement.dataset.markers);
    if (mapElement) { // only build a map if there's a div#map to inject into
      mapboxgl.accessToken = mapElement.dataset.mapboxApiKey;
      const map = new mapboxgl.Map({
        container: "mapbox",
        style: 'mapbox://styles/mapbox/streets-v10'
      })  
      this.fitMapToMarkers(map, markers);
      markers.forEach((marker) => {
        const popup = new mapboxgl.Popup().setHTML(marker.infoWindow);
          new mapboxgl.Marker() 
            .setLngLat([ marker.lng, marker.lat ])
            .setPopup(popup)
            .addTo(map);
          
      });
    }   
  }
}
