class NaiveLRU_Cache
  def initialize(size)
    @size = size
    @cache = []
  end

  def consume(stream)
    stream.split("").each{ |d| add_data(d) }
  end

  def add_data(val)
    unless reset_data(val)
      trash_eldest if @cache.length >= @size
      @cache << datum(val)
    end
    age
  end

  def reset_data(val)
    data = @cache.find{ |d| d[:val] == val }
    if data
      data[:age] = 0
      return true
    end
    false
  end

  def trash_eldest
    eldest = @cache.max{ |d1, d2| d1[:age] <=> d2[:age] }
    @cache.delete(eldest)
  end

  def datum(val)
    { age: 0, val: val }
  end

  def age
    @cache.each{|data| data[:age] += 1 }
  end

  def print
    sorted = @cache.sort{ |d1, d2| d2[:age] <=> d1[:age] }
    data_str = ""
    sorted.each{ |d| data_str += d[:val] }
    puts data_str
  end
end

simulation = 1

File.open("data.txt").each_line do |line|
  size, data = line.split
  size = size.to_i
  break if size == 0
  streams = data.split("!")
  lru = NaiveLRU_Cache.new(size)
  p "Simulation #{simulation}"
  streams.each do |stream|
    lru.consume(stream)
    lru.print
  end

  simulation += 1
end
