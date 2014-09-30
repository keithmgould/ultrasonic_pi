class Array
  def sum
    inject(0.0) { |result, el| result + el }
  end

  def mean 
    return 0 unless size > 0
    sum / size
  end
end
