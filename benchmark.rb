require 'benchmark'
require 'parallel'
require './fibonacci'
require './thread_pool'

@fibonaccis_to_calculate = [12, 6, 15, 2, 5, 8, 12, 5, 2, 12, 12, 11, 15, 12, 5, 15, 5, 1, 14, 2, 13]

def fibonacci_with_sleep_threaded
  result = []
  threads = @fibonaccis_to_calculate.map do |fibonacci_number|
    Thread.new do
      result.push([fibonacci_number, Fibonacci.with_sleep(fibonacci_number)])
    end
  end

  threads.each { |thread| thread.join }

  result
end

def fibonacci_with_sleep_unthreaded
  @fibonaccis_to_calculate.map do |fibonacci_number|
    [fibonacci_number, Fibonacci.with_sleep(fibonacci_number)]
  end
end

def fibonacci_without_sleep_threaded
  result = []
  threads = @fibonaccis_to_calculate.map do |fibonacci_number|
    Thread.new do
      result.push([fibonacci_number, Fibonacci.without_sleep(fibonacci_number)])
    end
  end

  threads.each { |thread| thread.join }

  result
end

def fibonacci_without_sleep_unthreaded
  @fibonaccis_to_calculate.map do |fibonacci_number|
    [fibonacci_number, Fibonacci.without_sleep(fibonacci_number)]
  end
end

def fibonacci_with_sleep_parallel(threads)
  Parallel.each(@fibonaccis_to_calculate, in_threads: threads) do |fibonacci_number|
    [fibonacci_number, Fibonacci.with_sleep(fibonacci_number)]
  end
end

def fibonacci_without_sleep_parallel(threads)
  Parallel.each(@fibonaccis_to_calculate, in_threads: threads) do |fibonacci_number|
    [fibonacci_number, Fibonacci.with_sleep(fibonacci_number)]
  end
end

def fibonacci_without_sleep_threaded_with_pool(threads)
  pool = ThreadPool.new(threads)

  @fibonaccis_to_calculate.each do |fibonacci_number|
    pool.schedule do
      Fibonacci.without_sleep(fibonacci_number)
    end
  end

  pool.run!
end

def fibonacci_with_sleep_threaded_with_pool(threads)
  pool = ThreadPool.new(threads)

  @fibonaccis_to_calculate.each do |fibonacci_number|
    pool.schedule do
      Fibonacci.with_sleep(fibonacci_number)
    end
  end

  pool.run!
end

puts 'Testes sem sleep'
Benchmark.bm(25) do |benchmark|
  benchmark.report('unthreads: ') { fibonacci_without_sleep_unthreaded }
  benchmark.report('with threads no pool: ') { fibonacci_without_sleep_threaded }
  benchmark.report('with threads pool of 5: ') { fibonacci_without_sleep_threaded_with_pool(5) }
  benchmark.report('with threads pool of 10: ') { fibonacci_without_sleep_threaded_with_pool(10) }
  benchmark.report('with threads pool of 20: ') { fibonacci_without_sleep_threaded_with_pool(20) }
  benchmark.report('with threads pool of 40: ') { fibonacci_without_sleep_threaded_with_pool(40) }
  benchmark.report('parallel with 5 threads: ') { fibonacci_without_sleep_parallel(5) }
  benchmark.report('parallel with 10 threads: ') { fibonacci_without_sleep_parallel(10) }
  benchmark.report('parallel with 20 threads: ') { fibonacci_without_sleep_parallel(20) }
  benchmark.report('parallel with 40 threads: ') { fibonacci_without_sleep_parallel(40) }
end

puts 'Testes com sleep'
Benchmark.bm(25) do |benchmark|
  benchmark.report('unthreads: ') { fibonacci_with_sleep_unthreaded }
  benchmark.report('with threads no pool: ') { fibonacci_with_sleep_threaded }
  benchmark.report('with threads pool of 5: ') { fibonacci_with_sleep_threaded_with_pool(5) }
  benchmark.report('with threads pool of 10: ') { fibonacci_with_sleep_threaded_with_pool(10) }
  benchmark.report('with threads pool of 20: ') { fibonacci_with_sleep_threaded_with_pool(20) }
  benchmark.report('with threads pool of 40: ') { fibonacci_with_sleep_threaded_with_pool(40) }
  benchmark.report('parallel with 5 threads: ') { fibonacci_with_sleep_parallel(5) }
  benchmark.report('parallel with 10 threads: ') { fibonacci_with_sleep_parallel(10) }
  benchmark.report('parallel with 20 threads: ') { fibonacci_with_sleep_parallel(20) }
  benchmark.report('parallel with 40 threads: ') { fibonacci_with_sleep_parallel(40) }
end
