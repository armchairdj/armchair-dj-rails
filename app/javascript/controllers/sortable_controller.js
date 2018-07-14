import Sortable from "sortablejs";

import BaseController from "./base_controller";

export default class extends BaseController {
  initialize() {
    this.url     = this.data.get("url");
    this.param   = this.data.get("param");
    this.onError = _.bind(this.ajaxError,    this);
    this.updater = _.bind(this.handleUpdate, this);
  }

  setup() {
    this.createSortable();
  }

  teardown() {
    this.destroySortable();
  }

  createSortable() {
    this.sortable = Sortable.create(this.element, { onUpdate: this.updater });
  }

  destroySortable() {
    this.sortable.destroy();
  }

  handleUpdate() {
    this.sendRequest();
  }

  sendRequest() {
    $.ajax({
      method: "POST",
      url:    this.url,
      data:   this.params(),
      error:  this.onError
    });
  }

  params() {
    const params = {};

    params[this.param] = this.sortable.toArray();

    return params;
  }

  ajaxError(xhr, status, error) {
    this.destroySortable();

    alert("Something went wrong reordering these items. Please reload the page and try again.");
  }
}
