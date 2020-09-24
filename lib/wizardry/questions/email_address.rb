module Wizardry
  module Questions
    # Ask a respondant for an email address
    class EmailAddress < Wizardry::Questions::Answer
      def initialize(name)
        Rails.logger.debug("🧙 Adding email address question '#{name}'")
        super
      end

      def form_method
        :govuk_email_field
      end
    end
  end
end
