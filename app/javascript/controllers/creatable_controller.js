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
    this.scope              = this.data.get("scope");
    this.addOptionEventName = `creatable:option-add:${this.scope}`;
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
    if (!this.confirmCreate(userInput)) { return callback() }

    this.submitCreate(userInput, callback);
  }

  confirmCreate(userInput) {
    if (this.isUnique(userInput)) { return true }

    return window.confirm("There's already an item like that. Are you sure you want to create a duplicate?");
  }

  isUnique(userInput) {
    return !_.findWhere(_.values(this.selectize.options), { text: userInput });
  }

  submitCreate(userInput, callback) {
    $.ajax({
      method:   "POST",
      url:      this.data.get("url"),
      data:     this.createItemParams(userInput),
      success:  _.bind(this.ajaxSuccess, this, callback),
      error:    _.bind(this.ajaxError,   this, callback)
    });
  }

  createItemParams(userInput) {
    return Object.assign(
      this.extraParams(),
      this.formParams(),
      this.userParam(userInput)
    );
  }
  
  userParam(userInput) {
    const obj = {};

    obj[ this.data.get("param") ] = userInput;

    return obj;
  }

  extraParams() {
    const params = this.data.get("extra-params");

    if (params) {
      return params.split("&").reduce(reducer, {});
    } else {
      return {};
    }

    function reducer(memo, param) {
      const parts = param.split("=");

      memo[ parts[0] ] = parts[1];

      return memo;
    }
  }

  formParams() {
    const $form  = $(this.element).parents("form");
    const params = this.data.get("form-params")

    if (params) {
      return params.split("&").reduce(reducer, {});
    } else {
      return {};
    }

    function reducer(memo, param) {
      const parts  = param.split("=");

      memo[ parts[0] ] = $form.find(`[name='${parts[1]}']`).val();

      return memo;
    }
  }

  ajaxSuccess(callback, response, status, xhr) {
    this.addAll($.makeArray(response), callback);
  }

  ajaxError(callback, xhr, status, error) {
    alert("Something went wrong. Please reload the page and try again.");

    callback();
  }

  addAll(items, callback) {
    const added = items.map(this.addOne, this);

    callback(added[0]);

    this.selectize.refreshItems();
  }

  addOne(raw) {
    const safe = raw || {};
    const item = { value: safe.id, text: safe.name }

    this.selectize.addOption(item);

    this.selectize.addItem(item.value, true);

    return item;
  }

  handleOptionAdd(value, params) {
    const memo = {
      scope:   this.scope,
      value:   params.value,
      text:    params.text,
    };

    if (this.constructor.memoized(memo)) { return }

    this.constructor.memoize(memo);

    this.broadcastToSiblings(memo);
  }

  broadcastToSiblings(memo) {
    const data = Object.assign(memo, { element: this.element });

    $(document).trigger(this.addOptionEventName, data);
  }

  handleRemoteOptionAdd(evt, params) {
    if ($(this.element) === $(params.element)) { return }

    this.selectize.addOption({ value: params.value, text: params.text });
  }
}
