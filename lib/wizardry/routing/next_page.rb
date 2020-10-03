module Wizardry
  module Routing
    class NextPage
      attr_reader :next_page, :condition

      def initialize(next_page, condition)
        @next_page = next_page
        @condition = condition
      end
    end
  end
end
