module Wizardry
  module Questions
    # Ask a date question
    class Date < Wizardry::Questions::Answer
      def initialize(name)
        Rails.logger.debug("🧙 Adding date question '#{name}'")
        super
      end

      def form_method
        :govuk_date_field
      end
    end
  end
end
