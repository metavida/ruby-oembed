module OEmbed
  # Uses {oEmbed Discover}[http://oembed.com/#section4] to generate a new Provider
  # instance about a URL for which a Provider didn't previously exist.
  class ProviderDiscovery
    class << self

    # Discover the Provider for the given url, then call Provider#raw on that provider.
    # The query parameter will be passed to both discover_provider and Provider#raw
    def raw(url, query={})
      provider = discover_provider(url, query)
      provider.raw(url, options)
    end

    # Discover the Provider for the given url, then call Provider#get on that provider.
    # The query parameter will be passed to both discover_provider and Provider#get
    def get(url, query={})
      provider = discover_provider(url, query)
      provider.get(url, query)
    end

    # Returns a new Provider instance based on information from oEmbed discovery
    # performed on the given url.
    #
    # The options Hash recognizes the following keys:
    # :format:: If given only discover endpoints for the given format. If not format is given, use the first available format found.
    def discover_provider(url, options = {})
      uri = URI.parse(url)

      res = Net::HTTP.start(uri.host, uri.port) do |http|
        http.get(uri.request_uri)
      end

      case res
      when Net::HTTPNotFound
        raise OEmbed::NotFound, url
      when Net::HTTPOK
        format = options[:format]

        if format.nil? || format == :json
          provider_endpoint ||= /<link.*href=['"]*([^\s'"]+)['"]*.*application\/json\+oembed.*>/.match(res.body)
          provider_endpoint ||= /<link.*application\/json\+oembed.*href=['"]*([^\s'"]+)['"]*.*>/.match(res.body)
          format ||= :json if provider_endpoint
        end
        if format.nil? || format == :xml
          provider_endpoint ||= /<link.*href=['"]*([^\s'"]+)['"]*.*application\/xml\+oembed.*>/.match(res.body)
          provider_endpoint ||= /<link.*application\/xml\+oembed.*href=['"]*([^\s'"]+)['"]*.*>/.match(res.body)
          format ||= :xml if provider_endpoint
        end

        begin
          provider_endpoint = URI.parse(provider_endpoint && provider_endpoint[1])
          provider_endpoint.query = nil
          provider_endpoint = provider_endpoint.to_s
        rescue URI::Error
          raise OEmbed::NotFound, url
        end

        Provider.new(provider_endpoint, format || OEmbed::Formatter.default)
      else
        raise OEmbed::UnknownResponse, res.code
      end
    end

    end
  end
end
