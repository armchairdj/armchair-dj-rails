import BaseController from "../controllers/base_controller";

export default class extends BaseController {
  setup() {
    // Code to be called on Stimulus#connect.
  }

  teardown(evt) {
    // Code to be called on a turbolinks visit away from the current page.
  }
}
