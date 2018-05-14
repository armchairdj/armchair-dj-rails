import { Controller } from "stimulus";

export default class extends Controller {
  static targets = [ "trigger", "tab", "remove" ];

  connect() {
    this.setup();

    $(document).on("turbolinks:visit", _.bind(this.teardown, this));
  }

  setup() {
    this.$managed = $(this.triggerTargets).add(this.tabTargets);

    this.showTab(this.data.get("selected-tab"));

    this.listener = $(document).on("tabgroup:activate", _.bind(this.activateFromAfar, this));

    $(this.removeTargets).remove();
    $(this.element).addClass("initialized");
  }

  teardown(evt) {
    $document.off("tabgroup:activate", this.listener);

    this.$managed.removeClass("tab-active tab-inactive");
  }

  activate(evt) {
    evt.preventDefault();

    this.showTab($(evt.target).attr("data-tab-name"));
  }

  activateFromAfar(evt, data) {
    this.showTab(data.tabName);
  }

  showTab(tabName) {
    const $active   = this.$managed.filter(`[data-tab-name=${tabName}]`);
    const $inactive = this.$managed.not($active);

    $active.removeClass(  "tab-inactive").addClass("tab-active"  );
    $inactive.removeClass("tab-active"  ).addClass("tab-inactive");
  }
}
