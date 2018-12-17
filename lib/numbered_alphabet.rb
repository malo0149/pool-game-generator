module NumberedAlphabet
	# Returns the nth letter of the alphabet
	def self.get_alpha(n)
		#TODO: Handle number > 26
		@@letters ||= alphabet_numbers
		if n.between?(1,26)
			@@letters[n.to_i]
		end
	end

	private
	def self.alphabet_numbers
		alphabet = ("A".."Z").to_a
		letters = ActiveSupport::OrderedHash.new
		(1..26).each { |i| letters[i] = alphabet[i-1]}
		letters
	end
end