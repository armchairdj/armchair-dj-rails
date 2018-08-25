import BaseController from "./base_controller";

export default class extends BaseController {
  static targets = [ "field" ];

  initialize() {
    this.maskText   = "conceal";
    this.unmaskText = "reveal";
  }

  setup() {
    this.$trigger = $(this.triggerMarkup()).appendTo(this.element);

    this.mask();
  }

  teardown(evt) {
    this.$trigger.remove();
  }

  triggerMarkup() {
    return '<a href="#" data-action="unmaskable#toggle" class="trigger" />';
  }

  toggle(evt) {
    evt.preventDefault();

    if (this.masked) {
      this.unmask();
    } else {
      this.mask();
    }
  }

  unmask() {
    $(this.fieldTarget).prop("type", "text");

    this.$trigger.text(this.maskText);

    this.masked = false;
  }

  mask() {
    $(this.fieldTarget).prop("type", "password");

    this.$trigger.text(this.unmaskText);

    this.masked = true;
  }
}
