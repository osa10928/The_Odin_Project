def divide(array)
  a = array[0...(array.length/2)]
  b = array[(array.length/2)..-1]
  return a, b
end

def conquer(a, b)
  sorted = []
  until a.length == 0 || b.length == 0
  sorted << (a[0] <= b[0] ? a.shift : b.shift)
  end
  (sorted << a << b).flatten
end

def merge_sort(array)
  if array.length > 1
    a, b = divide(array)
  array = conquer(merge_sort(a), merge_sort(b))
  end
  return array
end

merge_sort([3, 5, 7, 35, 5, 2])


  