module OEmbed
  module Formatter
    # Handles parsing JSON values using the best available backend.
    module JSON
      # A Array of all available backends, listed in order of preference.
      DECODERS = %w(ActiveSupportJSON JSONGem OkJson)
      
      class << self
        include ::OEmbed::Formatter::Base
        
        # Temporarily warn about the Yaml backend being deprecated.
        def backend_with_deprecation_warning=(new_backend)
          
          # If the user is trying to use the Yaml backend, warn them that it's no longer supported
          # then fall back to using the OkJson backend.
          case new_backend
          when 'Yaml'
            warn "DEPRECATION WARNING: The YAML/YAJL parser for JSON has been removed from ruby-oembed, for security reasons. Falling back to the OkJson parser instead."
            new_backend = 'OkJson'
          end
          
          # Now that we're using a safe backend
          # call the original OEmbed::Formatter::Base.backend= method.
          self.backend_without_deprecation_warning = new_backend
        end
        # Alias method chain
        alias_method 'backend_without_deprecation_warning=', 'backend='
        alias_method 'backend=', 'backend_with_deprecation_warning='
        
        # Returns the current JSON backend.
        def backend
          set_default_backend unless defined?(@backend)
          raise OEmbed::FormatNotSupported, :json unless defined?(@backend)
          @backend
        end

        def set_default_backend
          DECODERS.find do |name|
            begin
              self.backend = name
              true
            rescue LoadError
              # Try next decoder.
              false
            end
          end
        end
        
        private
        
        def backend_path
          'json/backends'
        end
        
        def test_value
          <<-JSON
{"version":"1.0", "string":"test", "int":42,"html":"<i>Cool's</i>\\n the \\"word\\"\\u0021"}
          JSON
        end
        
      end # self
      
    end # JSON
  end
end