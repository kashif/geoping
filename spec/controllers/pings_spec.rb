require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe Pings, "index action" do
  before(:each) do
    dispatch_to(Pings, :index)
  end
end