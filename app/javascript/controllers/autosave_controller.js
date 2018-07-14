const toObject = require("form-to-object");

import BaseController from "./base_controller";

export default class extends BaseController {
  initialize() {
    this.duration  = 60 * 1000;
    this.wait      = 30 * 1000;

    this.url       = this.data.get("url");

    this.detector  = _.debounce(_.bind(this.detectUpdate,    this), this.wait);
    this.saver     =            _.bind(this.saveIfNecessary, this);
    this.onSuccess =            _.bind(this.ajaxSuccess,     this);
    this.onError   =            _.bind(this.ajaxError,       this);
  }

  setup() {
    $(this.element).find("input, select, textarea").on("change keydown", this.detector);

    this.startInterval();
  }

  teardown(evt) {
    this.$fields.off("change", this.detector);

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
    if (this.lastUpdated > this.lastSaved) {
      this.submitRequest();
    }
  }

  submitRequest() {
    $.ajax({
      method:   "POST",
      url:      this.url,
      data:     toObject(this.element),
      success:  this.onSuccess,
      error:    this.onError
    });
  }

  ajaxSuccess(response, status, xhr) {
    console.log("autosaved");

    this.lastSaved = new Date();

    this.alertUserOfSuccess();
  }

  alertUserOfSuccess() {
    var $body = $("body");

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
