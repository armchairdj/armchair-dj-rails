import { Controller } from "stimulus";

export default class extends Controller {
  static targets = [ "fieldset" ];

  connect() {
    this.$node     = $(this.element);
    this.$fieldset = $(this.fieldsetTargets)
    this.$radio    = this.$node.find('input[type="radio"][name="creator[primary]"]');

    this.$radio.on("change", _.bind(this.handleChange, this));


    console.log("identities_controller");
    console.log(this.$radio);
    console.log(this.$fieldset);
    console.log(this.$radio.val());
  }

  handleChange(evt) {
    
    
  }

  toggle() {
    
    
  }
}
