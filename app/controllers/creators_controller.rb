class CreatorsController < PublicController

private

  def find_collection
    @creators = policy_scope(Creator).page(params[:page])
  end

  def find_instance
    @creator = Creator.find(params[:id])
  end

  def authorize_instance
    authorize @creator
  end
end
