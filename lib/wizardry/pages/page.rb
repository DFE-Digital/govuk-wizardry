module Wizardry
  module Pages
    class Page
      attr_reader :pages

      def initialize(pages: [])
        @pages  = pages
        @branch = false
      end

      def branch!
        @branch = true
      end

      def branch?
        @branch
      end

      def questions
        []
      end

      def next_pages
        []
      end
    end
  end
end
