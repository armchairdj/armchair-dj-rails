import { Controller } from "stimulus";

export default class extends Controller {
  dismiss(evt) {
    evt.preventDefault();

    $(this.element).remove();
  }
}
