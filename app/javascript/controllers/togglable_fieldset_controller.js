import BaseController from "./base_controller";

export default class extends BaseController {
  static targets = [ "trueFieldset", "falseFieldset" ];

  initialize() {
    this.toggler = _.bind(this.toggle, this);
  }

  setup() {
    this.findRadio().on("change", this.toggler);

    this.toggle();
  }

  teardown(evt) {
    this.findRadio().off("change", this.toggler);
  }

  findRadio() {
    return $(this.element).find('input[type="radio"]');
  }

  toggle(evt) {
    const $true  = $(this.trueFieldsetTarget);
    const $false = $(this.falseFieldsetTarget);

    if (this.findRadio().filter(":checked").val() === "true") {
      $false.hide();
      $true.show();
    } else {
      $true.hide();
      $false.show();
    }
  }
}
