module Wizardry
  module Questions
    class Hidden < Answer
      attr_reader :name

      def initialize(name, value)
        Rails.logger.debug("🧙 Adding hidden field '#{name}'")
        @value = value

        super(name)
      end

      def form_method
        :hidden_field
      end

      def extra_kwargs
        { value: @value }
      end
    end
  end
end
