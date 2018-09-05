import BaseController from "../controllers/base_controller";

export default class extends BaseController {
  dismiss(evt) {
    evt.preventDefault();

    $(this.element).remove();
  }
}
