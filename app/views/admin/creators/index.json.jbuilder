# frozen_string_literal: true

json.array! @creators, partial: "admin/creators/creator", as: :creator
