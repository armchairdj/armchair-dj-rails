import SelectizeMultiController from "controllers/selectize_multi_controller";

export default class extends SelectizeMultiController {
  constructOptions() {
    return Object.assign(super.constructOptions(), {
      create: _.bind(this.createItem, this)
    });
  }

  createItem(userInput, callback) {
    $.ajax({
      method:   "POST",
      url:      this.data.get("url"),
      data:     this.postParams(userInput),
      success:  _.bind(this.ajaxSuccess, this, callback),
      error:    _.bind(this.ajaxError,   this, callback)
    });
  }

  postParams(userInput) {
    var params = {};

    params["tag[name]"] = userInput;

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