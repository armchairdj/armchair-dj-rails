# frozen_string_literal: true

class UserSorter < Sorter
  def allowed
    super.merge({
      "Name"     => alpha_sort_sql,
      "Username" => author_sort_sql,
      "Email"    => user_email_sort_sql,
      "Role"     => [user_role_sort_sql, alpha_sort_sql],
    })
  end

private

  def model_class
    User
  end

  def user_email_sort_sql
    "LOWER(users.email) ASC"
  end

  def user_role_sort_sql
    "users.role ASC"
  end
end
