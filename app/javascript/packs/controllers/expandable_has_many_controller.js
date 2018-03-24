import { Controller } from "stimulus"

import $ from "jquery";

export default class extends Controller {
  connect() {
    this.$node   = $(this.element);
    this.$items  = this.$node.find("fieldset");
    this.$hidden = this.$items.filter(this.shouldHide);

    if (this.hideItems()) {
      this.createNodes();
    }
  }

  shouldHide() {
    return !$(this).find(".form-field:first-child select").val()
  }

  hideItems() {
    /* Always show the first one even if it has no value. */
    if (this.$hidden.length == this.$items.length) {
      this.$hidden.splice(0, 1);
    }

    this.$hidden.hide();

    return this.$hidden.length > 0;
  }

  createNodes() {
    this.$link = this.getLinkHtml();

    var $wrapper = $('<div class="expand">');

    this.$node.append($wrapper);

    $wrapper.append(this.$link);
  }

  getLinkHtml() {
    return $('<a href="#" data-action="click->expandable-has-many#expand">add another</a>');
  }

  expand(evt) {
    evt.preventDefault();

    $(this.$hidden.splice(0, 1)).remove().insertBefore(this.$link).show();

    if (this.$hidden.length === 0) {
      this.$link.remove();
    }
  }
}
