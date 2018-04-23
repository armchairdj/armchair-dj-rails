import { Controller } from "stimulus";

export default class extends Controller {
  static targets = [ "medium", "role" ];

  connect() {
    this.setup();

    $(document).on("turbolinks:visit", _.bind(this.teardown, this));
  }

  setup() {
    this.originalRoleMarkup = $(this.roleTargets)[0].outerHTML;

    $(this.mediumTargets).on("change", _.bind(this.handleMediumChange, this));
  }

  handleMediumChange(evt) {
    this.rememberValues();

    $(this.roleTargets).replaceWith(this.originalRoleMarkup);

    const grouping   = $(this.mediumTargets).find(":selected").data().workGrouping;
    const $options   = $(this.roleTargets).find("option[data-work-grouping]");
    const $removable = $options.filter(`option:not([data-work-grouping="${grouping}"])`);
    const $parents   = $removable.parent("optgroup");

    $parents.remove();

    this.restoreValues()
  }

  rememberValues() {
    this.vals = this.roleTargets.map(t => $(t).val());
  }

  restoreValues() {
    this.vals.forEach((v, i) => $(this.roleTargets[i]).val(v));
  }

  teardown(evt) {}
}
