import { Controller } from "stimulus";
import IMask from "imask";
import cep from 'cep-promise';

export default class extends Controller {
  static targets = [
    "name",
    "cep",
    "cpf",
    "cardNumber",
    "cardDueDate",
    "ccv",
    "button",
    "installments",
    "form",
    "couponCode",
    "alert",
    "street",
    "neighborhood",
    "city",
    "state"
  ];

  connect() {
    this.formTarget.style.display = "none"
    this.disableButton();
    IMask(this.cpfTarget, {
      mask: "000.000.000-00"
    });
    IMask(this.cepTarget, {
      mask: "00000-000"
    });
    IMask(this.cardNumberTarget, {
      mask: "0000 0000 0000 0000"
    });
    IMask(this.cardDueDateTarget, {
      mask: "00/00"
    });
    IMask(this.ccvTarget, {
      mask: "000"
    });
  }

  handleChange() {
    if (
      this.nameTarget.value &&
      this.cpfTarget.value &&
      this.cepTarget.value &&
      this.cardNumberTarget.value &&
      this.cardDueDateTarget.value &&
      this.ccvTarget.value &&
      this.verifyDate() &&
      this.verifyCpf()
    ) {
      this.enableButton();
    } else {
      this.disableButton();
    }
  }

  disableButton() {
    this.buttonTarget.disabled = true;
  }

  enableButton() {
    this.buttonTarget.disabled = false;
  }

  showForm() {
    this.formTarget.style.display = "block";
  }

  changeColor(e) {
    e.target.style.border = "2px solid green"
  }

  setAddress() {

    const zip = this.cepTarget.value
    if (zip.length == 9) {
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
  verifyDate() {
   if (this.cardDueDateTarget.value.match("^(0[1-9]|10|11|12)/[2-5][0-9]$")) {
    this.cardDueDateTarget.style.border = "2px solid green"
     return true
   } else {
    this.cardDueDateTarget.style.border = "2px solid red"
    // this.alertTarget.innerText= "bla"
    return false
   }
  }

  verifyCpf() {
    if (this.cpfTarget.value.match("^([0-9]{3}\.?[0-9]{3}\.?[0-9]{3}\-?[0-9]{2}|[0-9]{2}\.?[0-9]{3}\.?[0-9]{3}\/?[0-9]{4}\-?[0-9]{2})")) {
      this.cpfTarget.style.border = "2px solid green"
      return true
    } else {
      this.cpfTarget.style.border = "2px solid red"
     return false
    }
   }

   dateAlert() {
    // this.alertTarget.innerText= "bla bla"
   } 

  checkCoupon() {
    this.couponCodeTarget
    Rails.ajax({
      type: "POST",
      url: "/transitions",
      data: datas
    })
  }
  startPayment(){
    this.alertTarget.text
  }
}
