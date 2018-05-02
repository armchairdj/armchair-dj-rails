class GenresController < PublicController

private

  def find_collection
    @genres = policy_scope(Genre)
  end

  def find_instance
    @genre = Genre.find(params[:id])
  end

  def authorize_instance
    authorize @genre
  end

  def set_meta_tags
    @meta_description = @genre.summary
  end
end
