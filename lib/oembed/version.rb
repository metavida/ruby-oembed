module OEmbed
  class Version
    MAJOR = 0
    MINOR = 8
    PATCH = 9
    STRING = "#{MAJOR}.#{MINOR}.#{PATCH}"

    class << self
      # A String representing the current version of the OEmbed gem.
      def inspect
        STRING
      end
      alias_method :to_s, :inspect
    end
  end

  VERSION = Version::STRING
end