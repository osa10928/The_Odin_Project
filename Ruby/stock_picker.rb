def stock_picker(array)
  greatest_diff = nil 
  values = []
  i = 0 
  
  while i < array.length - 1
    j = i + 1
    diff = nil
    while j < array.length
      diff = array[j] - array[i]
      if greatest_diff == nil or greatest_diff < diff
        greatest_diff = diff
        values = [i, j]
      end
      j += 1
    end
    i += 1
  end
    

  
  return values
end
  
  
puts stock_picker([17,3,6,9,15,8,6,1,10])

=begin 
Saw this as somebodies solution. Pretty cool how they used each
They converted went from 1 to the last day and iterated calling
the day the first interation was on 'today' (subtacted 1 to have
it start at 0). Then the iterated over the iteration (i) calling
the next interation future. Created delta, assigned delta as best
if it was greater than the previous best and recorded the indicies
of today and future. Better than my while loops for sure. 




  def stock_picker prices
  best = [0,0,0] # delta, buy, sell
  last = prices.length-1
  (1..last).each do |i|
    today = i-1
    (i..last).each do |future|
      delta = prices[future]-prices[today]
      best  = [delta,today,future] if delta > best[0]
    end
  end
  best[1..2]
end
=end

