module Wizardry
  module Pages
    class QuestionPage < Page
      attr_accessor :name, :questions, :title, :next_pages

      def initialize(name, title: nil, questions:, next_pages: {}, pages: [])
        Rails.logger.debug("🧙 Adding page '#{name}' with #{questions&.size || 'no' } questions")

        @name       = name
        @title      = title || name.capitalize
        @questions  = questions
        @next_pages = next_pages

        super(pages: pages)
      end

      def question_names
        @questions.map(&:name)
      end
    end
  end
end