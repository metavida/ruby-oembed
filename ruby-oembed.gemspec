# -*- encoding: utf-8 -*-

lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'oembed/version'

Gem::Specification.new do |s|
  s.name = "ruby-oembed"
  s.version = OEmbed::Version.to_s

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Magnus Holm", "Alex Kessinger", "Aris Bartee", "Marcos Wright Kuhns"]
  s.date = "2012-11-19"
  s.description = "An oEmbed consumer library written in Ruby, letting you easily get embeddable HTML representations of supported web pages, based on their URLs. See http://oembed.com for more information about the protocol."
  s.email = "arisbartee@gmail.com"
  s.homepage = "http://github.com/judofyr/ruby-oembed"
  s.licenses = ["MIT"]

  s.files = `git ls-files`.split("\n")
  s.test_files = s.files.grep(%r{^(test|spec|features,integration_test)/})

  s.rdoc_options = ["--main", "README.rdoc", "--title", "ruby-oembed-#{OEmbed::Version}", "--inline-source", "--exclude", "tasks", "CHANGELOG.rdoc"]
  s.extra_rdoc_files = s.files.grep(%r{\.rdoc$}) + %w{LICENSE}

  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.19"
  s.summary = "oEmbed for Ruby"

  dev_dependencies = [
    [%q<rake>, [">= 0"]],
    [%q<json>, [">= 0"]],
    [%q<xml-simple>, [">= 0"]],
    # New versions of nokogiri don't support Ruby 1.8.x
    (Gem::Version.new(RUBY_VERSION) >= Gem::Version.new('1.9') ?
      [%q<nokogiri>, [">= 0"]] :
      [%q<nokogiri>, ["~>1.5.0"]]
    ),
    [%q<rspec>, [">= 2.0"]],
    [%q<vcr>, ["~> 1.0"]],
    [%q<fakeweb>, [">= 0"]],
  ]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      dev_dependencies.each do |gem|
        s.add_development_dependency(*gem)
      end
    else
      dev_dependencies.each do |gem|
        s.add_dependency(*gem)
      end
    end
  else
    dev_dependencies.each do |gem|
      s.add_dependency(*gem)
    end
  end
end

