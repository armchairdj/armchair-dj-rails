import SelectableController from "controllers/selectable_controller";

export default class extends SelectableController {
  static memos = [];

  static memoize(memo) {
    this.memos.push(memo);
  }

  static memoized(memo) {
    return !!_.findWhere(this.memos, memo);
  }

  initialize() {
    this.addOptionEventName = `selectable-create:option-add:${this.data.get("scope")}`;
    this.addOptionListener  = _.bind(this.handleRemoteOptionAdd, this);
  }

  setup() {
    super.setup();

    $(document).on(this.addOptionEventName, this.addOptionListener);
  }

  teardown(evt) {
    super.teardown();

    $(document).off(this.addOptionEventName, this.addOptionListener);
  }

  selectizeOpts() {
    return Object.assign(super.selectizeOpts(), {
      create:      _.bind(this.createItem,      this),
      onOptionAdd: _.bind(this.handleOptionAdd, this)
    });
  }

  createItem(userInput, callback) {
    if (!this.confirmCreate(userInput)) {
      return callback();
    }

    $.ajax({
      method:   "POST",
      url:      this.data.get("url"),
      data:     this.createItemParams(userInput),
      success:  _.bind(this.ajaxSuccess, this, callback),
      error:    _.bind(this.ajaxError,   this, callback)
    });
  }

  confirmCreate(userInput) {
    if (!_.findWhere(_.values(this.selectize.options), { text: userInput })) {
      return true;
    }

    return window.confirm("There's already an item like that. Are you sure you want to create a duplicate?");
  }

  createItemParams(userInput) {
    return Object.assign(
      this.extraParams,
      this.formParams,
      this.userParam(userInput)
    );
  }
  
  userParam(userInput) {
    const params = {};

    params[this.data.get("param")] = userInput;

    return params;
  }

  extraParams() {
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

  formParams() {
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

  handleOptionAdd(value, params) {
    const memo = {
      scope:   this.data.get("scope"),
      value:   params.value,
      text:    params.text,
    };

    if (!this.constructor.memoized(memo)) {
      this.constructor.memoize(memo);

      this.broadcastToSiblings(memo);
    }
  }

  broadcastToSiblings(memo) {
    memo = Object.assign(memo, { element: this.element });

    $(document).trigger(this.addOptionEventName, memo);
  }

  handleRemoteOptionAdd(evt, params) {
    if ($(this.element) === $(params.element)) {
      return;
    }

    this.selectize.addOption({ value: params.value, text: params.text });
    this.selectize.refreshOptions();
  }
}
