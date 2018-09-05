import BaseController from "../controllers/base_controller";

export default class extends BaseController {
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
      plugins:          [ "remove_button" ],
      closeAfterSelect: true
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
    const maxItems = parseInt(this.data.get("maxItems"), 10);

    return isNaN(maxItems) ? null : maxItems;
  }
}
