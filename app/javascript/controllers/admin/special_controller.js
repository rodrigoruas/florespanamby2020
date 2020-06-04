import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ["searchInput", "id"]

  connect() {
  }


  updateSearch() {
    var field = this.searchInputTarget.value
    var id = this.idTarget.innerHTML
    $.ajax({
      url: `/admin/special_orders/${id}`,
      method: "GET",
      data: {
        search: field
      }
    });
  }

  upQuantity(e) {
    const obj = e.target
    const id = obj.getAttribute("odid")
    $.ajax({
      url: "/admin/update_special",
      method: "POST",
      data: {
        order_details_id: id,
        quantity: "up"  
      }
    });
  }

  downQuantity(e) {
    const obj = e.target
    const id = obj.getAttribute("odid")
    $.ajax({
      url: "/admin/update_special",
      method: "POST",
      data: {
        order_details_id: id,
        quantity: "down"  
      }
    });
  }

}
