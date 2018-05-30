class TagsController < PublicController

private

  def find_collection
    @tags = scoped_collection
  end

  def find_instance
    @tag = scoped_instance_by_slug
  end
end
