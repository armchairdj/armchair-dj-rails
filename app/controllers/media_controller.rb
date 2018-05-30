class MediaController < PublicController

private

  def find_collection
    @media = scoped_collection
  end

  def find_instance
    @medium = scoped_instance_by_slug
  end
end
