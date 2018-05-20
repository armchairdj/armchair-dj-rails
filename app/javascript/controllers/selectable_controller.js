import { Controller } from "stimulus";

export default class extends Controller {
  connect() {
    $(document).on("turbolinks:visit", _.bind(this.teardown, this));

    this.multiple = $(this.element).is("[multiple]");

    $(this.element).selectize(this.constructOptions());

    this.selectize = this.element.selectize;
  }

  teardown(evt) {
    const selectizeInstance = $(this.element)[0].selectize;

    if (selectizeInstance) {
      selectizeInstance.destroy();
    }
  }

  constructOptions() {
    const maxItems = parseInt(this.data.get("maxItems"));

    if (this.multiple) {
      return {
        maxItems: isNaN(maxItems) ? null : maxItems,
        mode:     "multi",
        plugins:  [
          "remove_button"
        ]
      };
    } else {
      return {
        plugins:  [
          "remove_button"
        ]
      };
    }
  }
}
