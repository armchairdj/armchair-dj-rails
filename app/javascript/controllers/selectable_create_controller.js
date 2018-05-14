import SelectableController from "controllers/selectable_controller";

export default class extends SelectableController {
  connect() {
    super.connect();

    this.gatherData();
  }

  gatherData() {
    this.url   = this.data.get("url"),
    this.param = this.data.get("param");
  }

  constructOptions() {
    return Object.assign(super.constructOptions(), {
      create: _.bind(this.createItem, this)
    });
  }

  createItem(userInput, callback) {
    $.ajax({
      method:   "POST",
      url:      this.url,
      data:     this.postParams(userInput),
      success:  _.bind(this.ajaxSuccess, this, callback),
      error:    _.bind(this.ajaxError,   this, callback)
    });
  }

  postParams(userInput) {
    var params = {};

    params[this.param] = userInput;

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
