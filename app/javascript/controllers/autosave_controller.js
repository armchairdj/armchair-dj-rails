const toObject = require("form-to-object");

import BaseController from "./base_controller";

export default class extends BaseController {
  static intervalLength = 60 * 1000; /* one minute */

  initialize() {
    this.url            = this.data.get("url");
    this.submitter      = _.bind(this.submitRequest, this);
    this.successHandler = _.bind(this.ajaxSuccess,   this);
    this.errorHandler   = _.bind(this.ajaxError,     this);
  }

  setup() {
    this.beginInterval();
  }

  teardown(evt) {
    this.endInterval();
  }

  beginInterval() {
    this.interval = window.setInterval(this.submitter, this.constructor.intervalLength);
  }

  endInterval() {
    window.clearInterval(this.interval);
  }

  submitRequest() {
    $.ajax({
      method:   "POST",
      url:      this.url,
      data:     toObject(this.element),
      success:  this.successHandler,
      error:    this.errorHandler
    });
  }

  ajaxSuccess(response, status, xhr) {
    console.log("autosaved");//TODO
  }

  ajaxError(xhr, status, error) {
    this.endInterval();

    alert("Something went wrong auto-saving this post. You may want to manually save your changes.");
  }
}
