require 'spec_helper'

describe GreekString do
  let(:gs) { GreekString.new }
  it 'has a version number' do
    expect(GreekString::VERSION).not_to be nil
  end
end
