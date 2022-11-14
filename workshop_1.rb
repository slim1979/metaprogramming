# frozen_string_literal: true

module Memoize
  def memoize(name, as: nil)
    unbound = instance_method(name)
    define_method name do |*args|
      cache_key = "@#{as.presence || name}_#{args.hash}"
      return instance_variable_get(cache_key) if instance_variable_defined?(cache_key)

      cached_value = unbound.bind(self).call(*args)
      instance_variable_set(cache_key, cached_value)
    end
  end
end

class Example
  extend Memoize

  memoize def sum(x, y)
    x + y
  end
  memoize def foo
    rand
  end
  memoize def bar
            rand
  end, as: :@bar_cached
end
