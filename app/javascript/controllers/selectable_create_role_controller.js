import SelectableCreateController from "controllers/selectable_create_controller";

export default class extends SelectableCreateController {
  postParams(userInput) {
    const params = super.postParams(userInput);

    const mediumId = $("[data-target='work-dropdowns.medium']").val();

    console.log("mediumId");

    params["role[medium_id]"] = mediumId;

    return params
  }
}
