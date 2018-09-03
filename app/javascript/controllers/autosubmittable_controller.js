import BaseController from "./base_controller";

export default class extends BaseController {
  static targets = [ "field", "button" ];
  static hideClass = "js-visually-hidden";

  initialize() {
    /* Manually bind because of selectize */
    this.submitter = _.bind(this.submit, this);
  }

  setup() {
    $(this.fieldTargets).on("change", this.submitter);

    $(this.buttonTargets).addClass(this.constructor.hideClass);
  }

  teardown() {
    $(this.fieldTargets).off("change", this.submitter);

    $(this.buttonTargets).removeClass(this.constructor.hideClass);
  }

  submit(evt) {
    $(this.buttonTarget).click();
  }
}
