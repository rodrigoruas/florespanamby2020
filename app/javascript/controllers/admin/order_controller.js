import { Controller } from "stimulus";

export default class extends Controller {
  static targets = [ "orderId" ]

  connect() {
  }

  upQuantity(e) {
    const obj = e.target
    const id = obj.getAttribute("odid")
    const qty = obj.getAttribute("odqty")
    $.ajax({
      url: `/admin/special_orders/${id}`,
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
  deliveryCalculator(e) {
    $.ajax({
      url: "/admin/update_price",
      method: "POST",
      data: {
        order_id: this.orderIdTarget.value,
        order: {
          delivery_cost_id: e.target.value
        }
      }
    });
  }

}
