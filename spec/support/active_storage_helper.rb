# frozen_string_literal: true

module ActiveSupportHelper
  extend self
  extend ActionDispatch::TestProcess

  def png
    upload(png_name, "image/png")
  end

  def png_name
    "test.png"
  end

  def jpg
    upload(jpg_name, "image/jpeg")
  end

  def jpg_name
    "test.jpg"
  end

  def pdf
    upload(pdf_name, "application/pdf")
  end

  def pdf_name
    "test.pdf"
  end

  private

  def upload(name, type)
    file_path = Rails.root.join("spec", "support", "assets", name)

    fixture_file_upload(file_path, type)
  end
end
