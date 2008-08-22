require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe Json, "index action" do
  before(:each) do
    dispatch_to(Json, :index)
  end
end