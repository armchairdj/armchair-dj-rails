import BaseController from "./base_controller";

export default class extends BaseController {
  static targets = [ "field", "button" ]

  initialize() {
    this.handler = _.bind(this.handleChange, this);
  }

  setup() {
    $(this.fieldTargets).on("change", this.handler);

    $(this.buttonTargets).css({ visibility: "hidden", height: 0 });
  }

  teardown() {
    $(this.fieldTargets).off("change", this.handler);
  }

  handleChange(evt) {
    $(this.buttonTarget).click();
  }
}
