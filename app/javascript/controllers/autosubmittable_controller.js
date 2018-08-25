import BaseController from "./base_controller";

export default class extends BaseController {
  static targets = [ "field", "button" ]

  initialize() {
    this.submitter = _.bind(this.handleChange, this);
  }

  setup() {
    $(this.fieldTargets).on("change", this.submitter);

    $(this.buttonTargets).addClass("js-visually-hidden");
  }

  teardown() {
    $(this.fieldTargets).off("change", this.submitter);
  }

  handleChange(evt) {
    $(this.buttonTarget).click();
  }
}
