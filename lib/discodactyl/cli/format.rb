module Discodactyl # :nodoc
module CLI # :nodoc
# Formatting helpers for various rels
class Format
  def self.for_rel(rel)
    case rel
    when 'http://microformats.org/profile/hcard' then
      lambda {|uri, io| Discodactyl::CLI::Format.hcard_from_uri(uri, io) }
    when 'http://schemas.google.com/g/2010#updates-from' then
      lambda {|uri, io| Discodactyl::CLI::Format.activities_from_uri(uri, io) }
    else
      if name = Discodactyl::KNOWN_RELS[rel]
        lambda {|uri, io| io.puts "#{name}: #{uri}" if uri }
      else
        lambda {|uri, io| }
      end
    end
  end

  def self.hcard_adr(adr)
    segments = []
    segments << adr.street_address if adr.properties.include?(:street_address)
    segments << adr.locality if adr.properties.include?(:locality)
    segments << adr.region if adr.properties.include?(:region)
    segments << adr.postal_code if adr.properties.include?(:postal_code)
    segments << adr.country_name if adr.properties.include?(:country_name)
    segments.join(' ')
  end

  def self.hcard_from_uri(uri, io)
    begin
      Discodactyl.log.debug("hCard lookup for #{uri}") if Discodactyl.log
      if hcards = Prism.find(uri, :hcard)
        hcards.each do |hcard|
          if hcard
            io << "Name: #{hcard.fn.gsub(/\s+/, ' ')}\n" if hcard.properties.include?(:fn)
            io << "Title: #{hcard.title}\n" if hcard.properties.include?(:title)
            io << "Organization: #{hcard.org}\n" if hcard.properties.include?(:org)
            io << "Address: #{hcard_adr(hcard.adr)}\n" if hcard.properties.include?(:adr)
          end
        end
      end
    rescue RuntimeError => e
      Discodactyl.log.warn(e.message) if Discodactyl.log
      Discodactyl.log.debug(e) if Discodactyl.log
    end
  end

  def self.activities_from_uri(uri, io)
    Discodactyl.log.debug("Activity feed lookup for #{uri}") if Discodactyl.log
    begin
      if uri && (feed = Feedzirra::Feed.fetch_and_parse(uri)) && feed.respond_to?(:entries)
        Array(feed.entries).each do |entry|
          include ActionView::Helpers::DateHelper
          silence_warnings do
            io.puts "Status: #{Loofah::Helpers.strip_tags(entry.content)} #{time_ago_in_words(entry.published)} ago"
          end
        end
      else
        Discodactyl.log.debug("Failed activity feed lookup with uri: #{uri.inspect} feed: #{feed.inspect}") if Discodactyl.log
      end
    rescue
      Discodactyl.log.warn($!) if Discodactyl.log
    end
  end

end
end
end
