import { Controller } from "stimulus";

export default class extends Controller {
  connect() {
    this.setup();

    $(document).on("turbolinks:visit", _.bind(this.teardown, this));
  }

  setup() {
    $(this.element).selectize(this.selectizeOpts());

    this.selectize = this.element.selectize;
  }

  teardown(evt) {
    if (this.selectize) {
      this.selectize.destroy();
    }
  }

  selectizeOpts() {
    if ($(this.element).is("[multiple]")) {
      return {
        plugins:  [ "remove_button" ],
        maxItems: this.maxItems(),
        mode:     "multi"
      };
    } else {
      return {
        plugins: [ "remove_button" ]
      };
    }
  }

  maxItems() {
    const maxItems = parseInt(this.data.get("maxItems"));

    return isNaN(maxItems) ? null : maxItems;
  }
}
