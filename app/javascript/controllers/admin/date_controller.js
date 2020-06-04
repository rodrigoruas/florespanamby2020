import { Controller } from "stimulus";
import Pikaday from "pikaday";
import moment from "moment-timezone";
import places from 'places.js';

export default class extends Controller {
  static targets = ["zipcode", "cep", "id", "datepicker", "input", "city", "state", "neighborhood", "latitude", "longitude", "street", "streetNumber", "input"]

  connect() {
    this.setPikaday()
    this.setAutoComplete()
  }

  setPikaday() {
    var i18n = {
      previousMonth: "Mês anterior",
      nextMonth: "Próximo mês",
      months: [
        "Janeiro",
        "Fevereiro",
        "Março",
        "Abril",
        "Maio",
        "Junho",
        "Julho",
        "Agosto",
        "Setembro",
        "Outubro",
        "Novembro",
        "Dezembro"
      ],
      weekdays: [
        "domingo",
        "segunda-feira",
        "terça-feira",
        "quarta-feira",
        "quinta-feira",
        "sexta-feira",
        "sábado"
      ],
      weekdaysShort: ["Dom", "Seg", "Ter", "Qua", "Qui", "Sex", "Sab"]
    };


    new Pikaday({
      field: this.datepickerTarget,
      format: "DD / MM / YYYY",
      i18n: i18n,
      defaultDate: moment(),
      setDefaultDate: true
      // minDate: moment()
      //     .add(1, "h")
      //     .toDate()
      });
  }

  setAutoComplete() {
    var placesAutocomplete = places({
      appId: "plEK679GNI63",
      apiKey: "fcfc9e56c4a62bae98a5074c01d9b807",
      container: this.inputTarget,
      templates: {
        value: function(suggestion) {
          return suggestion.name + ", " + suggestion.suburb  + " - " + suggestion.administrative
        }
      }
    }).configure({
      countries: ["br"],
      type: "address",
      language: "pt-br",
      aroundLatLngViaIP: false
    });  
    placesAutocomplete.on('change', e => {
      this.streetTarget.value = e.suggestion.name
      this.streetTarget.removeAttribute("disabled")
      this.cityTarget.value = e.suggestion.city
      this.stateTarget.value = e.suggestion.administrative
      this.cepTarget.value = e.suggestion.postcode
      this.neighborhoodTarget.value = e.suggestion.suburb
      this.latitudeTarget.value = e.suggestion.latlng.lat
      this.longitudeTarget.value = e.suggestion.latlng.lng
      this.streetNumberTarget.style.border = "2px solid red"
    })
  }

  handleChange() {
    if (
        this.streetNumberTarget.value
      ) {
        this.streetNumberTarget.style.border = "2px solid green"
    }
  }

    

  showMessage() {
    document.getElementById("order-message").style.display = "block";
  }
}
