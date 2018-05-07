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
      const $select  = $(select);
      const $option  = $select.find(":selected")
      const current  = $select.val();
      const hidden   = $option.parents("optgroup.disabled")[0];
      const $restore = $select.find("optgroup:not(.disabled) option[data-previous-val]")
      const previous = $restore.attr("data-previous-val");

      if (hidden) {
        if (current) {
          $select.val("");
          $option.attr("data-previous-val", current);
        }
      } else {
        if (previous) {
          $select.val(previous);
          $option.removeAttr("data-previous-val");
        }
      }
    });
  }
}
