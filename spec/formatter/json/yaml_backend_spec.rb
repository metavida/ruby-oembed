require File.dirname(__FILE__) + '/../../spec_helper'

describe "OEmbed::Formatter::JSON::Backends::Yaml" do
  include OEmbedSpecHelper

  it "should be deprecated and fall back to OkJson" do
    lambda {
      OEmbed::Formatter::JSON.backend = 'Yaml'
    }.should_not raise_error
    
    OEmbed::Formatter::JSON.backend.should == OEmbed::Formatter::JSON::Backends::OkJson
  end

end