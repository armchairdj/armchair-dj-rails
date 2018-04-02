import { Controller } from "stimulus";

export default class extends Controller {
  static targets = [ "trigger", "tab" ];

  connect() {
    this.setup();

    $(document).on("turbolinks:visit", _.bind(this.teardown, this));
  }

  setup() {
    this.$targets = $(this.triggerTargets).add(this.tabTargets);

    this.showTab(this.data.get("selected-tab"));

    this.listener = $(document).on("tabgroup:activate", _.bind(this.activateFromAfar, this));
  }

  teardown(evt) {
    $document.off("tabgroup:activate", this.listener);

    this.$targets.removeClass("tab-active tab-inactive");
  }

  activate(evt) {
    evt.preventDefault();

    this.showTab($(evt.target).attr("data-tab-name"));
  }

  activateFromAfar(evt, data) {
    this.showTab(data.tabName);
  }

  showTab(tabName) {
    const $active   = this.$targets.filter(`[data-tab-name=${tabName}]`);
    const $inactive = this.$targets.not($active);

    $active.removeClass("tab-inactive").addClass("tab-active");
    $inactive.removeClass("tab-active").addClass("tab-inactive");
  }
}
