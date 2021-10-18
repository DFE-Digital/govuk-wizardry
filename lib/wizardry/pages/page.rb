module Wizardry
  module Pages
    class Page
      attr_reader :pages

      def initialize(pages: [], before_edit: nil, before_update: nil, after_update: nil)
        @pages  = pages
        @branch = false

        # callbacks
        @before_edit   = before_edit
        @before_update = before_update
        @after_update  = after_update
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

      def before_edit!(object)
        return unless @before_edit

        @before_edit.call(object)
      end

      def before_update!(object)
        return unless @before_update

        @before_update.call(object)
      end

      def after_update!(object)
        return unless @after_update

        @after_update.call(object)
      end
    end
  end
end
