import SelectableController from "controllers/selectable_controller";

export default class extends SelectableController {
  connect() {
    super.connect();

    this.addOptionEventName = `selectable-create:option-add:${this.data.get("scope")}`;
    this.addOptionListener  = _.bind(this.handleRemoteOptionAdd, this);

    this.bindAddOptionListener();
  }

  bindAddOptionListener() {
    $(document).on(this.addOptionEventName, this.addOptionListener);
  }

  unbindAddOptionListener() {
    $(document).off(this.addOptionEventName, this.addOptionListener);
  }

  constructOptions() {
    return Object.assign(super.constructOptions(), {
      create:      _.bind(this.createItem,      this),
      onOptionAdd: _.bind(this.handleOptionAdd, this)
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

  handleOptionAdd(value, data) {
    console.log("handleOptionAdd", data);

    $(document).trigger(this.addOptionEventName, {
      element: this.element,
      value:   data.value,
      text:    data.text,
    });
  }

  handleRemoteOptionAdd(evt, data) {
    console.log("handleRemoteOptionAdd")
    if ($(this.element) === $(data.element)) {
      return;
    }

    console.log("match", this.scope);

    this.unbindAddOptionListener();

    this.selectize.addOption({ value: data.value, text: data.text });
    this.selectize.refreshOptions();

    setTimeout(_.bind(this.bindAddOptionListener, this), 1000);
  }
}
