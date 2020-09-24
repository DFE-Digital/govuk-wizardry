module Wizardry
  module Questions
    # Ask a respondant for a telephone number
    class TelephoneNumber < Wizardry::Questions::Answer
      def initialize(name)
        Rails.logger.debug("🧙 Adding telephone number question '#{name}'")
        super
      end

      def form_method
        :govuk_phone_field
      end
    end
  end
end
