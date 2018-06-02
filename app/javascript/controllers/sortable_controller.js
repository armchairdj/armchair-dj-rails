import Sortable from "sortablejs";

import BaseController from "./base_controller";

export default class extends BaseController {
  initialize() {
    this.url   = this.data.get("url");
    this.param = this.data.get("param");
  }

  setup() {
    this.sortable = Sortable.create(this.element, {
      onUpdate: _.bind(this.handleUpdate, this)
    });
  }

  teardown() {
    this.sortable.destroy();
  }

  handleUpdate() {
    this.sendRequest();
  }

  sendRequest() {
    $.ajax({
      method: "POST",
      url:    this.url,
      data:   this.params()
    });
  }

  params() {
    const params = {};

    params[this.param] = this.sortable.toArray();

    return params;
  }
}
