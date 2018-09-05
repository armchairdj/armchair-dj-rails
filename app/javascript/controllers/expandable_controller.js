import BaseController from "./base_controller";

export default class extends BaseController {
  static targets   = [ "item", "trigger" ];
  static selectors = {
    inputs: "select, textarea, input:not([type=checkbox]):not([type=radio])",
    errors: ".with-error"
  };

  setup() {
    this.hidden = this.determineItemsToHide();

    if (this.hidden.length === 0) { return }

    $(this.hidden).hide();

    this.addTrigger();
  }

  teardown(evt) {
    $(this.hidden).show();

    this.removeTrigger();
  }

  determineItemsToHide() {
    return this.itemTargets.filter(this.shouldHideItem, this);
  }

  shouldHideItem(item, index) {
    if (index === 0) { return false }

    return !this.hasError(item) && !this.hasValue(item);
  }

  hasError(item) {
    return $(item).find(this.constructor.selectors.errors).length > 0;
  }

  hasValue(item) {
    const inputs = $(item).find(this.constructor.selectors.inputs).get();

    return inputs.filter(input => !!$(input).val()).length > 0;
  }

  addTrigger() {
    const markup = [
      '<div class="expandable-expand" data-target="expandable.trigger">',
        '<a href="#expand" data-action="expandable#expand">',
          this.triggerText(),
        '</a>',
      '</div>'
    ].join("");

    this.$trigger = $(markup).appendTo(this.element);
  }

  triggerText() {
    return this.data.get("triggerText") || "add another";
  }

  removeTrigger() {
    if (this.hasTriggerTarget) {
      $(this.triggerTarget).remove();
    }
  }

  expand(evt) {
    evt.preventDefault();

    $(this.hidden.shift()).show();

    if (this.hidden.length === 0) {
      this.removeTrigger();
    }
  }
}
