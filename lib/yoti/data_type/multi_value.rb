module Yoti
  class MultiValue
    def initialize(items)
      raise(TypeError, "Arrays must be passed to #{self.class.name}") unless items.is_a?(Array)

      @original_items = items
      @items = items.dup
      @filters = []
    end

    def allow_type(type)
      filter { |value| value.is_a?(type) }
      self
    end

    def filter(&callback)
      @filters.push(callback)
      apply_filters
      self
    end

    def items
      apply_filters
      @items.clone.freeze
    end

    private

    def apply_filters
      @items = @original_items.dup

      if @filters.count.positive?
        @items.keep_if do |item|
          match = @filters.select { |callback| callback.call(item) }
          match.count.positive?
        end
      end

      @items.each do |item|
        next unless item.is_a?(MultiValue)

        @filters.each do |callback|
          item.filter { |value| callback.call(value) }
        end
      end
    end
  end
end
