module Wizardry
  module Routing
    class NextPage
      attr_reader :name, :condition, :label

      def initialize(name, condition = nil, label: nil)
        @name      = name
        @condition = condition
        @label     = label
      end
    end
  end
end
