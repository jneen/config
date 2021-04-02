def sums(n, t, *a)
  a.empty? && a = (1..9)
  flat = ->(x) { x.is_a?(Enumerable) ? x.map(&flat).flatten : x }
  a = flat[a]

  a.combination(n).filter { |c| c.sum == t }
end
