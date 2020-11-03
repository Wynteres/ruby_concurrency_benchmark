class Fibonacci
  def self.with_sleep(n)
    sleep(0.01) if n.odd?
    return n if (0..1).include? n

    (Fibonacci.with_sleep(n - 1) + Fibonacci.with_sleep(n - 2))
  end

  def self.without_sleep(n)
    return n if (0..1).include? n

    (Fibonacci.without_sleep(n - 1) + Fibonacci.without_sleep(n - 2))
  end
end
