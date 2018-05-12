class TagsController < PublicController

private

  def find_collection
    @tags = policy_scope(Tag).page(params[:page])
  end

  def find_instance
    @tag = Tag.find(params[:id])
  end

  def authorize_instance
    authorize @tag
  end

  def set_meta_tags
    @meta_description = @tag.summary
  end
end
