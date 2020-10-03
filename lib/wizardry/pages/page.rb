module Wizardry
  module Pages
    class Page
      attr_accessor :branch

      def initialize(branch: false)
        @branch = branch
      end

      alias_method :branch?, :branch
    end
  end
end
