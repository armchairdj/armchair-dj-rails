import { Controller } from "stimulus";

export default class extends Controller {
  static targets = [ "fieldset" ];

  connect() {
    this.$node     = $(this.element);
    this.$fieldset = $(this.fieldsetTargets)
    this.$radio    = this.$node.find('input[type="radio"][name="creator[collective]"]');

    this.$radio.on("change", _.bind(this.handleChange, this));

    this.toggle();
  }

  handleChange(evt) {
    this.toggle();
  }

  toggle() {
    if (this.$radio.filter(":checked").val() === "true") {
      if (this.$removed && this.$removed[0]) {
        this.$node.append(this.$removed);
      }
    } else {
      this.$removed = this.$fieldset.remove();
    }
  }
}
