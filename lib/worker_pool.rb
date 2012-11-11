require 'thread'

class WorkerPool
  BUFFER_SIZE = 1

  def initialize(worker_count)
    @queue = SizedQueue.new(BUFFER_SIZE)
    @workers = (1..worker_count).map { |i| start_worker(i) }
  end

  def perform(tasks, timeout, &block)
    countdown, accumulator = CountdownLatch.new(tasks.size), Queue.new
    tasks.each { |args| enqueue(countdown, accumulator, args, block) }
    countdown.wait(timeout)
    queue_to_array(accumulator)
  end

  def shutdown
    @workers.each(&:kill)
  end

  private

  def enqueue(countdown, accumulator, args, block)
    @queue.push([ countdown, accumulator, args, block ])
  end

  def execute_task(countdown, accumulator, args, block)
    result =
      begin
        block.call(*args)
      rescue => ex
        WorkerError.new(ex)
      end
    accumulator.push(result)
  ensure
    countdown.decrement
  end

  def queue_to_array(queue)
    queue.length.times.map { queue.pop }
  end

  def start_worker(id)
    Thread.new do
      loop do
        task = @queue.pop rescue nil
        if Array === task
          execute_task(*task)
        end
      end
    end
  end
end

require 'worker_pool/countdown_latch'
require 'worker_pool/version'
require 'worker_pool/worker_error'
