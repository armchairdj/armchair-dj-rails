const toObject = require("form-to-object");

import BaseController from "../controllers/base_controller";

export default class extends BaseController {
  static sixtySeconds  = 60 * 1000;
  static thirtySeconds = 30 * 1000;
  static events        = "change keydown";

  initialize() {
    this.duration  = this.constructor.sixtySeconds;
    this.wait      = this.constructor.thirtySeconds;

    this.detector  = _.debounce(_.bind(this.detectUpdate, this), this.wait);

    this.saver     = _.bind(this.saveIfNecessary, this);
    this.onSuccess = _.bind(this.ajaxSuccess,     this);
    this.onError   = _.bind(this.ajaxError,       this);
  }

  setup() {
    this.$fields = $(this.element).find("input, select, textarea");

    this.$fields.on(this.constructor.events, this.detector);

    this.startInterval();
  }

  teardown(evt) {
    this.$fields.off(this.constructor.events, this.detector);

    this.endInterval();
  }

  startInterval() {
    this.failureCount = 0;

    this.lastUpdated = this.lastSaved = new Date();

    this.interval = window.setInterval(this.saver, this.duration);
  }

  endInterval() {
    window.clearInterval(this.interval);
  }

  detectUpdate(evt) {
    this.lastUpdated = new Date();
  }

  saveIfNecessary() {
    if (this.skipSave()) { return }

    this.submitRequest();
  }

  skipSave() {
    return this.lastUpdated <= this.lastSaved;
  }

  submitRequest() {
    $.ajax({
      method:   "POST",
      url:      this.data.get("url"),
      data:     toObject(this.element),
      success:  this.onSuccess,
      error:    this.onError
    });
  }

  ajaxSuccess(response, status, xhr) {
    this.lastSaved = new Date();

    this.alertUserOfSuccess();
  }

  alertUserOfSuccess() {
    const $body = $("body");

    $body.fadeTo(400, 0.5, function () {
      $body.fadeTo(400, 1)
    });
  }

  ajaxError(xhr, status, error) {
    this.failureCount += 1;

    if (this.failureCount >= 3) {
      this.alertUserOfError();
    }
  }

  alertUserOfError() {
    alert("Something went wrong auto-saving this post. You may want to manually save your changes and reload the page.");

    this.endInterval();
  }
}
