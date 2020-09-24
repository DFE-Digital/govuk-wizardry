module Wizardry
  module Questions
    # Ask a question that can be answered with multiple lines of text
    class LongAnswer < Wizardry::Questions::Answer
      def initialize(name)
        Rails.logger.debug("🧙 Adding long question '#{name}'")
        super
      end

      def form_method
        :govuk_text_area
      end
    end
  end
end
