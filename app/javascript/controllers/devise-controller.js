import { Controller } from "stimulus";
import IMask from "imask";

export default class extends Controller {
  static targets = [
    "cpf",
    "phone"
  ];

  connect() {
    IMask(this.cpfTarget, {
      mask: "000.000.000-00"
    });

    IMask(this.phoneTarget, {
      mask: "+{55}(00)0000-00000"
    });
  }
}
