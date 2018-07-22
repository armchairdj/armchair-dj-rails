module SortClauses

private

  def alpha_sort
    "#{model_class.table_name}.alpha ASC"
  end

  def default_sort
    "#{model_class.table_name}.updated_at DESC"
  end

  def id_sort
    "#{model_class.table_name}.id ASC"
  end

  def name_sort
    "LOWER(#{model_class.table_name}.name) ASC"
  end

  def title_sort
    "LOWER(#{model_class.table_name}.title) ASC"
  end

  def user_username_sort
    "users.username ASC"
  end

  def work_medium_sort
    "LOWER(works.medium) ASC"
  end
end
