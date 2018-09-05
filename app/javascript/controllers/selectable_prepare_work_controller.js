import SelectableController from "../controllers/selectable_controller";

export default class extends SelectableController {
  selectizeOpts() {
    return Object.assign(super.selectizeOpts(), {
      create: _.bind(this.activateTab, this)
    });
  }

  activateTab(userInput, callback) {
    this.setInputValues(userInput);

    $(document).trigger("tabbable:activate", {
      tabName: this.data.get("tab-name")
    });

    callback();
  }

  setInputValues(userInput) {
    const vals   = userInput.split(": ");
    const title  = vals.splice(-1, 1)[0] || "";
    const artist = vals.splice( 0, 1)[0] || "";

    $(this.data.get("title-selector")).val(title);

    if (artist) {
      $(this.data.get("artist-selector"))[0].selectize.findOrCreateByText(artist);
    }
  }
}
