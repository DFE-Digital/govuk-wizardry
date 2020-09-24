module Wizardry
  module Pages
    class Page
      attr_accessor :name, :questions, :title

      def initialize(name, title: nil, questions:)
        Rails.logger.debug("🧙 Adding page '#{name}' with #{questions&.size || 'no' } questions")

        @name      = name
        @title     = title || name.capitalize
        @questions = questions
      end

      def question_names
        @questions.map(&:name)
      end
    end
  end
end
