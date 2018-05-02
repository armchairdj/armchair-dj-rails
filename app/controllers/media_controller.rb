class MediaController < PublicController

private

  def find_collection
    @media = policy_scope(Medium)
  end

  def find_instance
    @medium = Medium.find(params[:id])
  end

  def authorize_instance
    authorize @medium
  end

  def set_meta_tags
    @meta_description = @medium.summary
  end
end
