import { Controller } from "stimulus"

import $ from "jquery";

export default class extends Controller {
  dismiss(evt) {
    evt.preventDefault();

    $(this.element).remove();
  }
}
