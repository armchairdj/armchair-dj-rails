import { Controller } from "stimulus";

export default class extends Controller {
  static targets = [ "trigger", "tab" ];

  connect() {
    $(document).on("turbolinks:visit", _.bind(this.teardown, this));

    this.setup();
  }

  setup() {
    this.$targets = $(this.triggerTargets).add(this.tabTargets);

    this.showTab(this.data.get("default"));
  }

  activate(evt) {
    this.showTab($(evt.target).attr("data-tab-name"));
  }

  showTab(tabName) {
    const $active   = this.$targets.filter(`[data-tab-name=${tabName}]`);
    const $inactive = this.$targets.not($active);

    $active.removeClass("tab-inactive").addClass("tab-active");
    $inactive.removeClass("tab-active").addClass("tab-inactive");
  }

  teardown(evt) {
    this.$targets.removeClass("tab-active tab-inactive");
  }
}
