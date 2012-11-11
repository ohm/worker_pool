require 'thread'

class WorkerPool
  class CountdownLatch
    def initialize(count)
      @count, @mutex, @resource = count, Mutex.new, ConditionVariable.new
    end

    def decrement
      @mutex.synchronize do
        @count -= 1
        if @count <= 0
          @resource.broadcast
        end
      end
    end

    # TODO: Implement timeouts
    def wait(_timeout)
      @mutex.synchronize do
        if @count > 0
          @resource.wait(@mutex)
        else
          @resource.broadcast
        end
      end
    end
  end
end
