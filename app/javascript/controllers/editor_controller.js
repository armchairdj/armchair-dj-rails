import BaseController from "./base_controller";

export default class extends BaseController {
  setup() {
    this.editor = new InscrybMDE(this.editorOptions());
  }

  teardown() {
    this.editor.toTextArea();
    this.editor = nil;
  }

  editorOptions() {
    return {
      element:   this.element,
      forceSync: true
    };
  }
}
