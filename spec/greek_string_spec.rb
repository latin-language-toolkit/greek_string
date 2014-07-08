require 'spec_helper'

describe GreekString do
  let(:gs) { GreekString.new }
  let(:letter_ary) { gs.all }
  it 'has a version number' do
    expect(GreekString::VERSION).not_to be nil
  end

  describe ".letters" do
    it "returns a container object" do
      expect(letter_ary).to be_a(GreekString::Container)
    end

    it "contains letter objects" do
      plain_alpha = letter_ary[0]
      other_alphas = letter_ary[0..23]
      beta = letter_ary[24]
      expect(plain_alpha).to be_a_kind_of(GreekString::Letter)
      other_alphas.each do |obj|
        expect(obj).to be_a_kind_of(GreekString::Letter::Alpha)
      end
      expect(beta).to be_a_kind_of(GreekString::Letter::Beta)
    end
  end
end
