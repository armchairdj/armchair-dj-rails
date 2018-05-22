import Sortable from "sortablejs";

import { Controller } from "stimulus";

export default class extends Controller {
  connect() {
    this.setup();

    $(document).one("turbolinks:visit", _.bind(this.teardown, this));
  }

  setup() {
    this.url = this.data.get("url");

    this.sortable = Sortable.create(this.element, {
      onUpdate: _.bind(this.handleUpdate, this)
    });
  }

  teardown() {
    this.sortable.destroy();
  }

  handleUpdate() {
    console.log("update", this.sortable.toArray());

    this.sendRequest();
  }

  sendRequest() {
    $.ajax({
      method:   "POST",
      url:      this.url,
      data:     { facet_ids: this.sortable.toArray() },
      success:  _.bind(this.ajaxSuccess, this),
      error:    _.bind(this.ajaxError,   this)
    });
  }

  ajaxSuccess(response, status, xhr) {
    console.log("success");
  }

  ajaxError(xhr, status, error) {
    alert("Something went wrong.");
  }
}
