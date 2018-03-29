import { Controller } from "stimulus";

export default class extends Controller {
  connect() {
    this.$select = $(this.element);
    this.options = this.$select.data();

    this.$select.selectize(this.constructSelectizeOptions());
  }

  constructSelectizeOptions() {
    return {
      plugins: [
        "restore_on_backspace",
        "remove_button"
      ]
    };
  }
}
