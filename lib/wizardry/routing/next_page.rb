module Wizardry
  module Routing
    class NextPage
      attr_reader :name, :condition

      def initialize(name, condition)
        @name      = name
        @condition = condition
      end
    end
  end
end
