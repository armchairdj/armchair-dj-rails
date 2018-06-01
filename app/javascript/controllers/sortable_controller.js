import Sortable from "sortablejs";

import { Controller } from "stimulus";

export default class extends Controller {
  connect() {
    this.setup();

    $(document).one("turbolinks:visit", _.bind(this.teardown, this));
  }

  setup() {
    this.url   = this.data.get("url");
    this.param = this.data.get("param");

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
      data:   this.params(),
      error:  _.bind(this.ajaxError, this)
    });
  }

  params() {
    const params = {};

    params[this.param] = this.sortable.toArray();

    return params;
  }

  ajaxError(xhr, status, error) {
    alert("Something went wrong.");
  }
}
