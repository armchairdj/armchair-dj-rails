# frozen_string_literal: true

xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title         I18n.t("site.name")
    xml.description   I18n.t("site.tagline")
    xml.link          posts_url
    xml.pubDate       @posts.maximum(:published_at).to_s(:rfc822)
    xml.lastBuildDate @posts.maximum(:updated_at).to_s(:rfc822)
    xml.copyright     copyright_notice(english: true)
    xml.language      "en-us"

    @posts.each do |post|
      xml.item do
        xml.title       post_title(post)
        # xml.author    TODO email of author
        xml.pubDate     post.published_at.to_s(:rfc822)
        xml.link        url_for_post(post, full_url: true)
        xml.guid        url_for_post(post, full_url: true, format: :json)
        xml.description post.formatted_body
      end
    end
  end
end
