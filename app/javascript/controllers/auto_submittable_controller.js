import { Controller } from "stimulus";

export default class extends Controller {
  static targets = [ "field", "submit" ]

  connect() {
    $(this.fieldTargets).on("change", _.bind(this.handleChange, this));

    $(this.submitTargets).css("visibility", "hidden");
  }

  handleChange(evt) {
    $(this.submitTarget).click();
  }
}
