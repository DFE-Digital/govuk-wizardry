module Wizardry
  module Pages
    class CheckYourAnswersPage < Page
      attr_reader :title

      def initialize(title: 'Check your answers')
        super(pages: [])
      end

      def name
        :check_your_answers
      end
    end
  end
end
