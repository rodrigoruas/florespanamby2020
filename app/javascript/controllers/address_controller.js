import { Controller } from "stimulus";
import Pikaday from "pikaday";
import moment from "moment-timezone";
import places from 'places.js';
import i18n from 'i18n-js';
import geocoder from "geocoder";
import cep from 'cep-promise';
import IMask from "imask";

export default class extends Controller {
  static targets = [ 
      "zipcode", "cep", "id", "datepicker", "input", "city", "state", "neighborhood", 
      "latitude", "longitude", "street", "streetNumber", "input", "senderEmail",
      "algoliaInputs", "algoliaAddress", "zipcodeInputs", "button", "fields", "blockedDates"
    ]

  connect() {
    this.buttonTarget.disabled = true;
    this.setAutoComplete()
    this.setPikaday()
    IMask(this.cepTarget, {
      mask: "00000-000"
    });
  }


  hideAlgolia() {
    this.algoliaAddressTarget.classList.add("hidden")
    this.fieldsTarget.classList.remove("hidden")
    this.zipcodeInputsTarget.classList.remove("hidden")
    this.cepTarget.dataset.action = "keyup->address#zipcodeSearch"
    this.cepTarget.removeAttribute('disabled')
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
    // var classesNodeList = document.querySelectorAll(".blocked-date");
    // var enabled_dates = Array.prototype.slice.call(classesNodeList).map(function(element) {
    //   return element.innerHTML;
    // });
    new Pikaday({
      field: this.datepickerTarget,
      format: "DD / MM / YYYY",
      i18n: i18n,
      defaultDate: moment(),
      setDefaultDate: true,
    //   disableDayFn: function (date) {
        
    //     if ($.inArray(moment(date).format("YYYY-MM-DD"), enabled_dates) === 1) {
    //         console.log(date)
    //         return date;
    //     }
    // },
      minDate: moment()
          .add(1, "h")
          .toDate()
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
      this.cepTarget.removeAttribute('disabled')
      this.fieldsTarget.classList.remove("hidden")
    })
  }

  handleChange() {
    if (
        this.streetNumberTarget.value &&
        this.cityTarget.value &&
        this.stateTarget.value  &&
        this.cepTarget.value  &&
        this.neighborhoodTarget.value  &&
        this.datepickerTarget.value
      ) {
        this.buttonTarget.disabled = false;
    }
    if (this.streetNumberTarget.value) {
      this.streetNumberTarget.style.border = "2px solid green"
    }
  }

  enableButton() {
    this.buttonTarget.disabled = false;
  }

  showMessage() {
    document.getElementById("order-message").style.display = "block";
  }

  upQuantity(e) {
    const obj = e.target
    const id = obj.getAttribute("odid")
    const qty = obj.getAttribute("odqty")
    $.ajax({
      url: `/carrinho/${id}`,
      method: "PATCH",
      data: {
        order_details_id: id,
        order_detail: {
          quantity: parseInt(qty, 10) + 1
        }  
      }
    });
  }

  downQuantity(e) {
    const obj = e.target
    const id = obj.getAttribute("odid")
    const qty = obj.getAttribute("odqty")
    if (qty == 1) {
      $.ajax({
        url: `/carrinho/${id}`,
        method: "DELETE",
      });
    } else {
      $.ajax({
        url: `/carrinho/${id}`,
        method: "PATCH",
        data: {
          order_details_id: id,
          order_detail: {
            quantity: parseInt(qty, 10) - 1
          }  
        }
      });
    }
  }


  verifyEmail() {
    if (/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(this.senderEmailTarget.value)) {
      this.senderEmailTarget.style.border = "2px solid green"
      true
    } else {
      this.senderEmailTarget.style.border = "2px solid red"
      false
    }
  }

  zipcodeSearch() {
    const zip = this.cepTarget.value
    if (zip.length == 9) {
      this.streetTarget.removeAttribute('disabled')
      cep(zip).then( (response) => {
          var hash = response
          this.streetTarget.value = hash.street
          this.neighborhoodTarget.value = hash.neighborhood
          this.cityTarget.value = hash.city
          this.stateTarget.value = hash.state
          this.streetTarget.style.border = "2px solid green"
          this.neighborhoodTarget.style.border = "2px solid green"
          this.cityTarget.style.border = "2px solid green"
          this.stateTarget.style.border = "2px solid green"
      })
    } else {
    }

  }
}
