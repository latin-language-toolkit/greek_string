require 'spec_helper'

describe GreekString do
  let(:gs) { GreekString.new }
  it 'has a version number' do
    expect(GreekString::VERSION).not_to be nil
  end

  describe "#all" do
    it "returns all greek letters in an array" do
      ary = gs.all
      expect(ary).to include("α")
      expect(ary).to include("κ")
    end
  end

  describe "#find" do
    context "with vowels" do
      it "returns an array of vowels upper and lower case" do
        ary = gs.find("vowel")
        expect(ary).to include("α")
        expect(ary).to include("Η")
        expect(ary).not_to include("κ")
      end
    end

    context "with consonants" do
      it "returns an array of consonants upper and lower case" do
        ary = gs.find("consonant")
        expect(ary).not_to include("Η")
        expect(ary).to include("κ")
      end
    end

    context "with double_consonants" do
      it "returns an array of double_consonants upper and lower case" do
        ary = gs.find("double_consonant")
        expect(ary.length).to eq(6)
      end
    end
  end

  describe "#find_lower_case" do
    it "returns an array of lower case letters" do
      ary = gs.find_lower_case
      expect(ary).not_to include("Η")
      expect(ary).to include("κ")
    end
  end

  describe "#find_upper_case" do
    it "returns an array of lower case letters" do
      ary = gs.find_upper_case
      expect(ary).to include("Η")
      expect(ary).not_to include("κ")
    end
  end
end
