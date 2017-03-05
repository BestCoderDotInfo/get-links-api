require 'nokogiri'
require 'open-uri'

module Api::V1
  class InstagramController < ApiController
    def create
      info = get_info_from(instagram_url) if instagram_url
      render json: info
    end

    private

    def instagram_url
      params.require(:url)
    end

    def get_info_from(url)
      doc = get_doc(url)
      info = {}
      info[:url] = url
      doc.css('meta').each do |meta|
        info[:image] = meta['content'] if meta['property'] == 'og:image'
        info[:description] = meta['content'] if meta['property'] == 'og:description'
        info[:user] = meta['content'] if meta['property'] == 'instapp:owner_user_id'
      end
      info
    end

    def get_doc(path)
      user_agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_0) AppleWebKit/535.2 (KHTML, like Gecko) Chrome/15.0.854.0 Safari/535.2"
      Nokogiri::HTML.parse(open(path, {'User-Agent' => user_agent}))
    end
  end
end
