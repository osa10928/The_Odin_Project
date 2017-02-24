def bubble_sort (array)
  i = 0 
  while i < array.length - 1 
    if array[i] > array[i+1]
      array[i], array[i+1] = array[i+1], array[i]
      i = -1
    end
    i += 1 
  end
  return array
end


#to yield with a block

def bubble_sort_by(array)
 
  i = 0 
  while i < array.length - 1 
    left = array[i]
    right = array[i+1]
    if yield(left,right) > 0
      array[i], array[i+1] = array[i+1], array[i]
      i = -1
    end
    i += 1 
  end
  return array
end

 bubble_sort_by(["hi","hello","hey"]) do |left,right|
  left.length - right.length
 end
