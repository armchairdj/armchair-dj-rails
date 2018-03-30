import { Controller } from "stimulus";

export default class extends Controller {
  connect() {
    $(document).on("turbolinks:visit", _.bind(this.teardown, this));

    $(this.element).selectize(this.constructOptions());
  }

  teardown(evt) {
    const selectizeInstance = $(this.element)[0].selectize;

    if (selectizeInstance) {
      selectizeInstance.destroy();
    }
  }

  constructOptions() {
    return {
      plugins: [
        "restore_on_backspace",
        "remove_button"
      ]
    };
  }
}
