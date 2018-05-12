import { Controller } from "stimulus";

//TODO setup and teardown

export default class extends Controller {
  static targets = [ "trueFieldset", "falseFieldset", "radio" ];

  connect() {
    this.$node          = $(this.element);
    this.$trueFieldset  = $(this.trueFieldsetTargets)
    this.$falseFieldset = $(this.falseFieldsetTargets)
    this.$radio         = this.$node.find('input[type="radio"]');

    this.$radio.on("change", _.bind(this.handleChange, this));

    this.toggle();
  }

  handleChange(evt) {
    this.toggle();
  }

  toggle() {
    if (this.$radio.filter(":checked").val() === "true") {
      this.$trueFieldset.show();
      this.$falseFieldset.hide();
    } else {
      this.$falseFieldset.show();
      this.$trueFieldset.hide();
    }
  }
}
