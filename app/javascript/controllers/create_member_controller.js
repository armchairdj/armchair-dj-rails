import CreateCreatorController from "controllers/create_creator_controller";

export default class extends CreateCreatorController {
  postParams(userInput) {
    var params = super.postParams(userInput);

    params["creator[individual]"] = "true";

    return params;
  }
}
