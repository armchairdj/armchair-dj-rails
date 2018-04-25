class WorksController < PublicController

private

  def find_collection
    @works = policy_scope(Work).page(params[:page])
  end

  def find_instance
    @work = Work.find(params[:id])
  end

  def authorize_instance
    authorize @work
  end
end
