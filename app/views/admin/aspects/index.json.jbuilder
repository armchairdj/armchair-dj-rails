# frozen_string_literal: true

json.array! @aspects, partial: "admin/aspects/aspect", as: :aspect
