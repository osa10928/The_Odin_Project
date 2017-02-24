def fibonacci (n)
	if n <= 0
		return nil
	end
	if n == 1
		return [0]
	end
	sequence = [0, 1]
	until sequence.length == n
		sequence << sequence[-2] + sequence[-1]
	end
	return sequence
end

fibonacci(12)

def fibonacci(counter, sequence = [0, 1])
	return sequence[0] if counter == 1
	return sequence if counter == 2
	sequence << sequence[-2] + sequence[-1]
	fibonacci(counter - 1, sequence)
end

