import { Controller } from "stimulus"

import $ from "jquery";

export default class extends Controller {
  connect() {
    this.$select = $(this.element);
    this.options = this.$select.data();

    this.$select.selectize({
      create: _.bind(this.createItem, this)
    });
  }

  createItem(userInput, callback) {
    $.ajax({
      method:   this.options.selectCreateMethod,
      url:      this.options.selectCreateAction,
      data:     this.postParams(userInput),
      success:  _.bind(this.ajaxSuccess, this, callback),
      error:    _.bind(this.ajaxError,   this, callback)
    });
  }

  postParams(userInput) {
    var params = {};

    params[this.options.selectCreateParam] = userInput;

    return params;
  }

  ajaxSuccess(callback, data, status, xhr) {
    callback({
      value: data.id,
      text:  data.name
    });
  }

  ajaxError(callback, xhr, status, error) {
    alert("Something went wrong.");

    callback();
  }
}
