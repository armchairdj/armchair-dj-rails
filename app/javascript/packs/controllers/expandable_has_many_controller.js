import { Controller } from "stimulus";

export default class extends Controller {
  connect() {
    this.$node   = $(this.element);
    this.$items  = this.$node.find("fieldset");
    this.$hidden = this.$items.filter(this.shouldHide);

    this.deploy();
  }

  deploy() {
    if (this.hideItems()) {
      this.appendLink();
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

  appendLink() {
    this.$wrapper = $('<div class="expand">');
    this.$link    = this.getLinkHtml();

    this.$node.append(this.$wrapper);

    this.$wrapper.append(this.$link);
  }

  getLinkHtml() {
    return $('<a href="#" data-action="click->expandable-has-many#expand">add another</a>');
  }

  expand(evt) {
    evt.preventDefault();

    this.$wrapper.remove();

    $(this.$hidden.splice(0, 1)).show();

    if (this.$hidden.length > 0) {
      this.appendLink();
    }
  }
}
