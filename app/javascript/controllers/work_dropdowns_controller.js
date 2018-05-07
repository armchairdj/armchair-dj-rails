import { Controller } from "stimulus";

export default class extends Controller {
  static targets = [ "medium", "role" ];

  connect() {
    $(this.mediumTargets).on("change", _.bind(this.handleMediumChange, this));

    this.hideInvalid();
  }

  handleMediumChange(evt) {
    this.hideInvalid();
  }

  hideInvalid() {
    const grouping   = $(this.mediumTargets).find(":selected").data().grouping;
    const $options   = $(this.roleTargets).find("option[data-grouping]");
    const $optgroups = $options.parent("optgroup");
    const $invalid   = $options.filter(`option:not([data-grouping="${grouping}"])`);
    const $hide      = $invalid.parent("optgroup");

    if (grouping === this.previousGrouping) {
      return;
    }

    this.previousGrouping = grouping;

    $optgroups.removeClass("disabled");
    $hide.addClass("disabled");

    this.roleTargets.forEach(function (select, index) {
      const $select   = $(select);
      const $optgroup = $select.find(":selected").parent("optgroup");
      const current   = $select.val();
      const hidden    = $optgroup.hasClass("disabled");
      const $restore  = $select.find("optgroup[data-previous-val]:not(.disabled)")
      const previous  = $restore.attr("data-previous-val");

      if (hidden && typeof current !== "undefined") {
        $select.val("");
        $optgroup.attr("data-previous-val", current);
      } else if (!hidden && typeof previous !== "undefined") {
        $select.val(previous);
        $restore.removeAttr("data-previous-val");
      }
    });
  }
}
