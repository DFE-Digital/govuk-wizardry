module Wizardry
  module Questions
    class Answer
      attr_reader :name

      def initialize(name)
        @name = name
      end

      def extra_args
        []
      end

      def extra_kwargs
        {}
      end
    end
  end
end
