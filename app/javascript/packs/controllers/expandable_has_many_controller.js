import { Controller } from "stimulus";

export default class extends Controller {
  initialize() {
    this.$node   = $(this.element);
    this.$items  = this.$node.find("fieldset");
    this.$hidden = this.$items.filter(this.shouldHide);

    if (this.hideItems()) {
      this.appendLink();
    }
  }

  shouldHide() {
    return !$(this).find(".form-field:first-child select").val()
  }

  hideItems() {
    this.neverHideFirstItem();

    this.$hidden.hide();

    return this.$hidden.length > 0;
  }

  neverHideFirstItem() {
    if (this.$hidden.length == this.$items.length) {
      this.grabNextItem();
    }
  }

  grabNextItem() {
    return $(this.$hidden.splice(0, 1));
  }

  appendLink() {
    this.$link = this.getLinkHtml();

    this.$node.append(this.$link);
  }

  removeLink() {
    this.$link.remove();
  }

  getLinkHtml() {
    return $('<div class="expand"><a href="#" data-action="click->expandable-has-many#expand">add another</a></div>');
  }

  expand(evt) {
    evt.preventDefault();

    this.removeLink();

    this.grabNextItem().show();

    if (this.$hidden.length > 0) {
      this.appendLink();
    }
  }
}
