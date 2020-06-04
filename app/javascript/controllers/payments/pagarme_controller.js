import { Controller } from "stimulus";

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
  var checkout = new PagarMeCheckout.Checkout({
    encryption_key: "ek_live_LmQFnp0fIhHY77PP5rUx9r1QLzvTxM",
    success: function(data) {
      console.log(data);
    },
    error: function(err) {
        console.log(err);
    },
    close: function() {
        console.log('The modal has been closed.');
    }
  });
  console.log(checkout)
 }
}
