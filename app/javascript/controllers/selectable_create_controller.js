import SelectableController from "controllers/selectable_controller";

export default class extends SelectableController {
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
    return Object.assign(
      this.getParam(userInput),
      this.getExtraParams,
      this.getFormParams
    );
  }
  
  getParam(userInput) {
    const params = {};

    params[this.data.get("param")] = userInput;

    console.log("params", params);

    return params;
  }

  getExtraParams() {
    const params      = {};
    const extraParams = this.data.get("extra-params");

    if (extraParams) {
      _.each(extraParams.split("&"), function (param) {
        const parts = param.split("=");

        params[parts[0]] = parts[1];
      });
    }

    console.log("extraParams", params);

    return params;
  }

  getFormParams() {
    const params     = {};
    const formParams = this.data.get("form-params");

    if (formParams) {
      _.each(formParams.split("&"), function (param) {
        const parts = param.split("=");

        params[parts[0]] = $(this.element).parents("form").find(parts[1]).val();
      });
    }

    console.log("formParams", params);

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
