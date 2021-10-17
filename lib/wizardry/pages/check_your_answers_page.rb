module Wizardry
  module Pages
    class CheckYourAnswersPage < Page
      attr_reader :title, :questions

      def initialize(questions: [], title: 'Check your answers')
        @title     = title
        @questions = questions

        super(pages: [])
      end

      def name
        :check_your_answers
      end

      def question_names
        @questions.map(&:name)
      end
    end
  end
end
