# frozen_string_literal: true

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

  def set_meta_tags
    @meta_description = @work.summary
  end
end
