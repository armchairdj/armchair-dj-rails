import SelectizeController from "packs/controllers/selectize_controller";

export default class extends SelectizeController {
  constructOptions() {
    return Object.assign(super.constructOptions(), {
      create: _.bind(this.activateTab, this)
    });
  }

  activateTab(userInput, callback) {
    callback();

    $(document).trigger("tabgroup:activate", {
      userInput: userInput,
      tabName:   this.data.get("tab-name")
    });
  }
}
