# frozen_string_literal: true

json.array! @tags, partial: "admin/tags/tag", as: :tag
