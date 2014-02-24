require_relative "./spec_helper"

describe Yahm do
  it "has a module called HashMapper" do
    expect(Yahm.const_defined? :HashMapper).to be_true
    expect(Yahm::HashMapper.class.is_a? Module)
  end
end
