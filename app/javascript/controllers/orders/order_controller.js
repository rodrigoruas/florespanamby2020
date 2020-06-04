import { Controller } from "stimulus";

export default class extends Controller {
  static targets = [ "datepicker","orderId", "couponCode", "phone", "phoneSec", "senderPhone", "senderEmail", "button", "alert", "delivery"]

  connect() {

    this.disableButton()
    IMask(this.senderPhoneTarget, {
      mask: "(00)00000-0000"
    });
    IMask(this.phoneSecTarget, {
      mask: "(00)00000-0000"
    });
  }

  handleChange() {
    if (
      this.senderPhoneTarget.value &&
      this.senderEmailTarget.value &&
      this.deliveryTarget.value
    ) {
      
      this.verifyEmail()
      // this.enableButton();
    } else {
      this.disableButton();
    }
  }

  changeColor(e) {
    e.target.style.border = "2px solid green"
  }

  disableButton() {
    this.buttonTarget.disabled = true;
  }

  enableButton() {
    this.buttonTarget.disabled = false;
  }

  deliveryCalculator(e) {
    $.ajax({
      url: "/update_price",
      method: "POST",
      data: {
        order_id: this.orderIdTarget.value,
        order: {
          delivery_cost_id: e.target.value
        }
      }
    });
  }
  showRecipient() {
  }

  verifyEmail() {
    if (/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(this.senderEmailTarget.value)) {
      this.senderEmailTarget.style.border = "2px solid green"
      this.alertTarget.classList.add("hidden")
      this.enableButton();
      true
    } else {
      this.senderEmailTarget.style.border = "2px solid red"
      if (this.buttonTarget.disabled == false) {
        this.alertTarget.classList.remove("hidden")
        this.disableButton();
      }  
      false
    }
  }
}
