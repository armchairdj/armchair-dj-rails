import { Controller } from "stimulus";

export default class extends Controller {
  connect() {
    this.setup();

    $(document).one("turbolinks:visit", _.bind(this.teardown, this));
  }

  setup() {}

  teardown() {}
}
