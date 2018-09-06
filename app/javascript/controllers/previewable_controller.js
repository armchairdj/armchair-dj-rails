const toObject = require("form-to-object");

import BaseController from "../controllers/base_controller";

export default class extends BaseController {
  preview(evt) {
    const $form = $(this.element).parents("form");
  }
}
