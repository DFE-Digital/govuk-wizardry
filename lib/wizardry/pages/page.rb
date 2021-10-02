module Wizardry
  module Pages
    class Page
      attr_reader :pages

      def initialize(pages: [])
        @pages  = pages
        @branch = false
      end

      # mark this page as being a branch page
      def branch!
        @branch = true
      end

      def branch?
        @branch
      end
    end
  end
end
