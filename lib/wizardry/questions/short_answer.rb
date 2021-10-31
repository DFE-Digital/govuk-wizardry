module Wizardry
  module Questions
    # Ask a question that can be answered with one line of text
    class ShortAnswer < Wizardry::Questions::Answer
      def initialize(name)
        Rails.logger.debug("🧙 Adding short question '#{name}'")
        super(name)
      end

      def form_method
        :govuk_text_field
      end
    end
  end
end
