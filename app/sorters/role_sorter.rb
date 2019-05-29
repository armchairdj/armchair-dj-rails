# frozen_string_literal: true

class RoleSorter < Ginsu::Sorter
  def allowed
    super.merge(
      "Name"   => [name_sort_sql, role_medium_sort_sql],
      "Medium" => [role_medium_sort_sql, name_sort_sql]
    )
  end

private

  def model_class
    Role
  end

  def role_medium_sort_sql
    "LOWER(roles.medium) ASC"
  end
end
