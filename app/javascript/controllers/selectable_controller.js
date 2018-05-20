import { Controller } from "stimulus";

export default class extends Controller {
  connect() {
    this.setup();

    $(document).one("turbolinks:visit", _.bind(this.teardown, this));
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
    const opts = {
      plugins: [ "remove_button" ]
    };

    if ($(this.element).is(":not([multiple])")) {
      return opts;
    }

    return Object.assign(opts, {
      mode:     "multi",
      maxItems: this.maxItems()
    });
  }

  maxItems() {
    const maxItems = parseInt(this.data.get("maxItems"));

    return isNaN(maxItems) ? null : maxItems;
  }
}
