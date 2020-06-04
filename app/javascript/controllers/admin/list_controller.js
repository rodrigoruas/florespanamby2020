import { Controller } from "stimulus";
import Pikaday from "pikaday";
import moment from "moment-timezone";
export default class extends Controller {
  static targets = [ "datepicker", "dateInput" ]

  connect() {
    this.setPikaday()
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
      setDefaultDate: true,
      minDate: moment()
          .add(1, "h")
          .toDate()
      });
  }

  showInput() {
    this.dateInputTarget.classList.remove("hidden")
  }

  showOrder(e) {
    const index = e.target.dataset.index
    const element = document.getElementById(`order-${index}`)
    const expandButton = document.getElementById(`expand-${index}`)
    const hideButton = document.getElementById(`hide-${index}`)
    element.classList.remove("hidden")
    expandButton.classList.add("hidden")
    hideButton.classList.remove("hidden")
  }
  hideOrder(e) {
    const index = e.target.dataset.index
    const element = document.getElementById(`order-${index}`)
    const expandButton = document.getElementById(`expand-${index}`)
    const hideButton = document.getElementById(`hide-${index}`)
    element.classList.add("hidden")
    expandButton.classList.remove("hidden")
    hideButton.classList.add("hidden")

  }
}
