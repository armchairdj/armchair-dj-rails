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
      this.ensureLink();
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

  ensureLink() {
    this.$link = this.$node.find("[data-expand-link]");

    if (!this.$link[0]) {
      this.$link = this.getLinkHtml();

      this.$node.append(this.$link);
    }
  }

  removeLink() {
    this.$link.remove();
  }

  getLinkHtml() {
    return $('<div class="expand" data-expand-link="true"><a href="#" data-action="click->expandable-has-many#expand">add another</a></div>');
  }

  expand(evt) {
    evt.preventDefault();

    this.removeLink();

    this.grabNextItem().show();

    if (this.$hidden.length > 0) {
      this.ensureLink();
    }
  }
}
