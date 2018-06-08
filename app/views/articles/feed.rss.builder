# frozen_string_literal: true

xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title         I18n.t("site.name")
    xml.description   I18n.t("site.tagline")
    xml.link          articles_url
    xml.pubDate       @articles.maximum(:published_at).to_s(:rfc822)
    xml.lastBuildDate @articles.maximum(:updated_at).to_s(:rfc822)
    xml.copyright     copyright_notice(english: true)
    xml.language      "en-us"

    @articles.each do |article|
      xml.item do
        xml.title       article_title(article)
        # xml.author      I18n.t("site.owner")
        xml.pubDate     article.published_at.to_s(:rfc822)
        xml.link        article_permalink_path(slug: article.id)
        xml.guid        article.id
        xml.description formatted_post_body(article)
      end
    end
  end
end
