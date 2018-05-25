import { Controller } from "stimulus";

export default class extends Controller {
  static targets = [ "all", "remove" ];

  initialize() {
    this.handler = _.bind(this.activateFromAfar, this);
  }

  connect() {
    this.setup();

    $(document).one("turbolinks:visit", _.bind(this.teardown, this));
  }

  setup() {
    $(this.removeTargets).hide();

    $(this.element).addClass("initialized");

    this.showTab(this.data.get("selected-tab"));

    $(document).on("tabbable:activate", this.handler);
  }

  teardown(evt) {
    $(document).off("tabbable:activate", this.handler);

    $(this.allTargets).removeClass("tab-active tab-inactive");

    $(this.element).removeClass("initialized");

    $(this.removeTargets).show();
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