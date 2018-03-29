import SelectizeController from "packs/controllers/selectize_controller";

export default class extends SelectizeController {
  constructSelectizeOptions() {
    return Object.assign({}, super.constructSelectizeOptions(), {
      create: _.bind(this.createItem, this)
    });
  }

  createItem(userInput, callback) {
    $.ajax({
      method:   this.options.selectizeCreateMethod,
      url:      this.options.selectizeCreateAction,
      data:     this.postParams(userInput),
      success:  _.bind(this.ajaxSuccess, this, callback),
      error:    _.bind(this.ajaxError,   this, callback)
    });
  }

  postParams(userInput) {
    var params = {};

    params[this.options.selectizeCreateParam] = userInput;

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
