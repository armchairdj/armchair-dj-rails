import SelectizeController from "controllers/selectize_controller";

export default class extends SelectizeController {
  constructOptions() {
    return Object.assign(super.constructOptions(), {
      create: _.bind(this.createItem, this)
    });
  }

  createItem(userInput, callback) {
    $.ajax({
      method:   this.data.get("method"),
      url:      this.data.get("action"),
      data:     this.postParams(userInput),
      success:  _.bind(this.ajaxSuccess, this, callback),
      error:    _.bind(this.ajaxError,   this, callback)
    });
  }

  postParams(userInput) {
    var params = {};

    params[this.data.get("param")] = userInput;

    return params;
  }

  ajaxSuccess(callback, response, status, xhr) {
    callback({
      value: response.id,
      text:  response.name
    });
  }

  ajaxError(callback, xhr, status, error) {
    alert("Something went wrong.");

    callback();
  }
}
