import { Controller } from "stimulus"
import Siema from "siema"
import mapboxgl from 'mapbox-gl';
export default class extends Controller {
  static targets = ["mapdiv"]

  connect() {
    this.displayMap()
    const prodSlider = new Siema({
        selector: '.siema',
        innerWrapper: '.siema-inner',
        perPage: {
          500: 1.2,
          694: 3,
        //   1060: 5,
        }   
      });

      const prev = document.querySelector('.prev');
      const next = document.querySelector('.next');
      prev.addEventListener('click', () => prodSlider.prev());
      next.addEventListener('click', () => prodSlider.next());
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
