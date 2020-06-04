import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["searchInput"]

  connect() {
  }
  updateSearch() {
    var field = this.searchInputTarget.value
    $.ajax({
      url: "/produtos",
      method: "GET",
      data: {
        search: field
      }
    });
  }
}
