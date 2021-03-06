import BaseController from "../controllers/base_controller";

export default class extends BaseController {
  static targets = [ "all", "remove" ];

  initialize() {
    this.activator = _.bind(this.activateFromAfar, this);
  }

  setup() {
    $(this.removeTargets).hide();

    $(this.element).addClass("initialized");

    this.showTab(this.data.get("selected-tab"));

    $(document).on("tabbable:activate", this.activator);
  }

  teardown(evt) {
    $(this.removeTargets).show();

    $(this.element).removeClass("initialized");

    $(this.allTargets).removeClass("tab-active tab-inactive");

    $(document).off("tabbable:activate", this.activator);
  }

  activate(evt) {
    evt.preventDefault();

    this.showTab($(evt.target).attr("data-tab-name"));
  }

  activateFromAfar(evt, data) {
    this.showTab(data.tabName);
  }

  showTab(tabName) {
    const $all  = $(this.allTargets);
    const $show = $all.filter(`[data-tab-name=${tabName}]`);
    const $hide = $all.not($show);

    $show.removeClass("tab-inactive").addClass("tab-active"  );
    $hide.removeClass("tab-active"  ).addClass("tab-inactive");
  }
}
