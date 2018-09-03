import BaseController from "./base_controller";

export default class extends BaseController {
  static targets = [ "field" ];
  static text    = { mask: "conceal", unmask: "reveal" };

  initialize() {
    this.mask   = _.bind(this.performToggle, this, "password", "unmask", true );
    this.unmask = _.bind(this.performToggle, this, "text",     "mask",   false);
  }

  setup() {
    this.$trigger = this.createTrigger();

    this.enable();

    this.mask();
  }

  teardown(evt) {
    this.$trigger.remove();

    this.mask();
  }

  createTrigger() {
    const markup = '<a href="#" data-action="unmaskable#toggle" class="trigger" />';

    return $(markup).appendTo(this.element);
  }

  enable() {
    if (!!$(this.fieldTarget).val()) {
      this.$trigger.show();
    } else {
      this.$trigger.hide();
    }
  }

  toggle(evt) {
    evt.preventDefault();

    this.masked ? this.unmask() : this.mask();
  }

  performToggle(type, key, val) {
    $(this.fieldTarget).prop("type", type);

    this.$trigger.text(this.constructor.text[key]);

    this.masked = val;
  }
}
