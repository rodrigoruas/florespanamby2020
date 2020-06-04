class ReadableCode
  def self.generate(size = 8)
    chars = ('A'..'Z').to_a
    chars -= ['I', 'O']
    range = [*'0'..'9', *chars]
    Array.new(size) { range.sample }.join
  end
end
