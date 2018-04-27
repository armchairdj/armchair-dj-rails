# frozen_string_literal: true

json.array! @works, partial: "admin/works/work", as: :work
