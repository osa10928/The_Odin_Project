require "caesarcipher"
require "rspec_helper"

describe "caesar_cipher" do 
	it "shifts a single letter by int" do 
		expect(caesar_cipher("a", 1)).to eq("b")
	end

	it "shifts multiple letters by int" do
		expect(caesar_cipher("ant", 3)).to eq("dqw")
	end

	it "shifts 'z' back to 'a'" do
		expect(caesar_cipher("z", 1)).to eq("a")
	end

	it "conserves spaces when shifting multiple words" do
		expect(caesar_cipher("they ran", 5)).to eq("ymjd wfs")
	end

	it "it conserves punctuations" do 
		expect(caesar_cipher("why not?", 2)).to eq("yja pqv?")
	end

	it "does not allow for negative number shifts" do 
		expect { caesar_cipher("a", -1) }.to raise_error(ArgumentError)
	end
	
end