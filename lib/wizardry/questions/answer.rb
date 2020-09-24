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
    end
  end
end
