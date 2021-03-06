class DataImport::MyDramaList
  module Extractor
    class Details
      include Helpers

      attr_reader :dom
      def initialize(html)
        @dom = Nokogiri::HTML(html)
      end

      def details
        @details ||= dom.css('.show-details .txt-block').map do |row|
          # Grab the header, strip the whitespace and colon
          key = row.at_css('h4').content.strip.sub(/:\z/, '')
          # This little XPath query basically queries for *all* nodes (bare
          # text included) which are not H4 tags, so we get all the content in
          # the row.  Once we grab the content, we strip it of whitespace,
          # nuke the blank entries, and drop the array if it's singular.
          value = row.xpath('node()[not(self::h4)]').map(&:content).map(&:strip)
          value.reject!(&:blank?)
          value = value.one? ? value.first : value
          [key, value]
        end.to_h
      end

      def [](key)
        details[key]
      end

      def title
        dom.at_css('h1').content.strip
      end

      def synopsis
        dom.css('.show-synopsis > p').map(&:content).join('\n\n')
      end

      def genres
        dom.css('.show-genres > a').map(&:content).map(&:strip)
      end

      def poster_image
        # Extract the image and go fullsize
        original_for dom.at_css('.cover img')['src']
      end
    end
  end
end
