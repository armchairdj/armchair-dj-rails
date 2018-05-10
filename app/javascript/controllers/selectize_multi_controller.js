import SelectizeController from "controllers/selectize_controller";

export default class extends SelectizeController {
  constructOptions() {
    return {
      mode:     "multi",
      plugins:  [
        "remove_button"
      ]
    };
  }
}
