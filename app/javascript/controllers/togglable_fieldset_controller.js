import BaseController from "./base_controller";

export default class extends BaseController {
  static targets = [ "trueFieldset", "falseFieldset" ];

  initialize() {
    this.handler = _.bind(this.toggle, this);
  }

  setup() {
    this.findRadio().on("change", this.handler);

    this.toggle();
  }

  teardown(evt) {
    this.findRadio().off("change", this.handler);
  }

  findRadio() {
    return $(this.element).find('input[type="radio"]');
  }

  toggle(evt) {
    if (this.findRadio().filter(":checked").val() === "true") {
      $(this.trueFieldsetTarget).show();
      $(this.falseFieldsetTarget).hide();
    } else {
      $(this.trueFieldsetTarget ).hide();
      $(this.falseFieldsetTarget).show();
    }
  }
}
