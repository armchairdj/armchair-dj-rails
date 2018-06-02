import BaseController from "./base_controller";

export default class extends BaseController {
  static targets = [ "field" ];

  setup() {
    this.hidden = this.fieldTargets.filter(field => !$(field).find("select").val());

    if (this.hidden.length == this.fieldTargets.length) {
      this.hidden.shift();
    }

    if (this.hidden.length > 0) {
      $(this.hidden).hide();

      this.addLink();
    }
  }

  teardown(evt) {
    $(this.fieldTargets).show();

    this.removeLink();
  }

  addLink() {
    this.$link = $('<div class="expand" data-expand-link="true"><a href="#" data-action="expandable-fieldset#expand">add another</a></div>');

    $(this.element).append(this.$link);
  }

  removeLink() {
    $(this.element).find("[data-expand-link]").remove();
  }

  expand(evt) {
    evt.preventDefault();

    $(this.hidden.shift()).show();

    if (this.hidden.length === 0) {
      this.removeLink();
    }
  }
}
