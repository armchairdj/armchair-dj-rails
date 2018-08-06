import BaseController from "./base_controller";

export default class extends BaseController {
  static targets = [ "item" ];

  setup() {
    this.hidden = this.itemTargets.filter(this.shouldHideField, this);

    this.alwaysShowFirstItem();
    this.hideIfNecessary();
  }

  teardown(evt) {
    $(this.itemTargets).show();

    this.removeLink();
  }

  alwaysShowFirstItem() {
    if (this.hidden.length == this.itemTargets.length) {
      this.hidden.shift();
    }
  }

  hideIfNecessary() {
    if (this.hidden.length == 0) { return }

    $(this.hidden).hide();

    this.addLink();
  }

  shouldHideField(item) {
    if (this.itemHasErrors(item)) { return false }
    if (this.itemHasValues(item)) { return false }

    return true;
  }

  itemHasErrors(item) {
    const errors = $(item).find(".with-error");

    return errors.length > 0;
  }

  itemHasValues(item) {
    const inputs     = $(item).find("select, input:not([type=checkbox]):not([type=radio])").get();
    const withValues = inputs.filter(input => !!$(input).val());

    return withValues.length > 0;
  }

  addLink() {
    this.$link = $(this.linkMarkup());

    $(this.element).append(this.$link);
  }

  linkMarkup() {
    return [
      '<div class="expand" data-expand-link="true">',
        '<a href="#" data-action="expandable-fieldset#expand">add another</a>',
      '</div>'
    ].join("");
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
