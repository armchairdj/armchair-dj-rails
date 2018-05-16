import { Controller } from "stimulus";

export default class extends Controller {
  static targets = [ "medium", "role" ];

  connect() {
    $(this.mediumTarget).on("change", _.bind(this.handleMediumChange, this));

    this.hideInvalid();
  }

  handleMediumChange(evt) {
    this.hideInvalid();
  }

  hideInvalid() {
    const grouping = $(this.mediumTarget).find(":selected").data().grouping;

    if (grouping === this.previousGrouping) {
      return;
    }

    this.previousGrouping = grouping;

    this.setDisabled(grouping);

    this.roleTargets.forEach(_.bind(this.updateOptgroup, this));
  }

  setDisabled(grouping) {
    const $options   = $(this.roleTargets).find("option[data-grouping]");
    const $optgroups = $options.parent("optgroup");
    const $hide      = $options.filter(`option:not([data-grouping="${grouping}"])`).parent("optgroup");

    $optgroups.not($hide).removeClass("disabled");
    $hide.addClass("disabled");
  }

  updateOptgroup(select) {
    const $select     = $(select);
    const $optgroup   = $select.find(":selected").parent("optgroup");
    const $restore    = $select.find("optgroup[data-previous-val]:not(.disabled)")

    const hidden      = $optgroup.hasClass("disabled");
    const currentVal  = $select.val();
    const previousVal = $restore.attr("data-previous-val");

    if (hidden && typeof currentVal !== "undefined") {
      $select.val("");
      $optgroup.attr("data-previous-val", currentVal);
    } else if (!hidden && typeof previousVal !== "undefined") {
      $select.val(previousVal);
      $restore.removeAttr("data-previous-val");
    }
  }
}
