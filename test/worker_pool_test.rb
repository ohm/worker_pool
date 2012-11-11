require 'test_helper'
require 'worker_pool'

class WorkerPoolTest < MiniTest::Unit::TestCase
  TIMEOUT = 5.0

  def identity(arg)
    arg
  end

  def sleepy_identity(arg)
    sleep(rand(0.01..0.2))
    arg
  end

  def fail(*args)
    raise ArgumentError, args
  end

  def test_ordered_task_execution
    pool, args, task = WorkerPool.new(1), (0..9).to_a, method(:identity)
    results = pool.perform(args, TIMEOUT, &task)
    pool.shutdown
    assert_equal(args, results)
  end

  def test_concurrent_task_execution
    pool, args, task = WorkerPool.new(2), (0..9).to_a, method(:sleepy_identity)
    results = pool.perform(args, TIMEOUT, &task)
    pool.shutdown
    assert_equal(args.size, results.size)
    args.each { |arg| assert(results.include?(arg)) }
  end

  def test_failing_task_execution
    pool, args, task = WorkerPool.new(3), [ :a, :a, :a ], method(:fail)
    results = pool.perform(args, TIMEOUT, &task)
    pool.shutdown
    assert_equal(args.size, results.size)
    results.each { |r| assert(r.is_a?(WorkerPool::WorkerError)) }
    assert_equal([ :a ].inspect, results.first.message)
  end
end
