module Wizardry
  module Questions
    class Radios < Wizardry::Questions::Answer
      attr_reader :options

      RadioOption = Struct.new(:value, :label, keyword_init: true)

      def initialize(name, options)
        Rails.logger.debug("🧙 Adding radios '#{name}' with options #{options}")

        @options = options

        super(name)
      end

      def form_method
        :govuk_collection_radio_buttons
      end

      def extra_args
        [build_options, :value, :label]
      end

      def build_options
        case options
        when Array
          options.map { |v| Wizardry::Questions::Radios::RadioOption.new(value: v, label: v) }
        when Hash
          options.map { |k, v| Wizardry::Questions::Radios::RadioOption.new(value: k, label: v) }
        else
          fail ArgumentError, "Options must be an Hash or Array"
        end
      end
    end
  end
end
