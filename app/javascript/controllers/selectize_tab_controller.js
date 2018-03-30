import SelectizeController from "packs/controllers/selectize_controller";

export default class extends SelectizeController {
  constructOptions() {
    return Object.assign(super.constructOptions(), {
      create: _.bind(this.loadForm, this)
    });
  }

  loadForm(userInput, callback) {
    this.userInput = userInput;
    this.callback  = callback;

    this.requestForm();
  }

  requestForm() {
    $.ajax({
      url:      this.data.get("url"),
      method:   "get",
      success:  _.bind(this.loadSuccess, this),
      error:    _.bind(this.ajaxError,   this)
    });
  }

  loadSuccess(response, status, xhr) {
    this.markup  = response.form;
    this.$hidden = $(this.data.get("displayNode"))

    this.$hidden.hide().before(this.markup);

    this.$form = this.$node.parent().find("#new_work");

    this.$form.on("submit", _.bind(this.handleSubmit, this));
  }

  handleSubmit(evt) {
    $.ajax({
      method:   this.data.get("method"),
      url:      this.data.get("action"),
      data:     this.$form.serialize(),
      success:  _.bind(this.formSuccess, this),
      error:    _.bind(this.ajaxError,   this)
    });
  }

  formSuccess(response, status, xhr) {
    console.log("formSuccess");
    console.log(response);

    // this.callback({
    //   value: response.id,
    //   text:  response.name //TODO display_name?
    // });
  }

  ajaxError(xhr, status, error) {
    alert("Something went wrong.");

    this.callback();
  }
}
