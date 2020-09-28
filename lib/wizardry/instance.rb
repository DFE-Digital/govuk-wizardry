module Wizardry
  # Instance holds data specific to this page/response
  class Instance
    attr_accessor :current_page, :object, :framework

    def initialize(current_page:, object:, framework:)
      @object       = object
      @framework    = framework
      @current_page = @framework.pages.detect { |p| p.name == current_page.to_sym }

      raise ActionController::RoutingError.new('Wizard page not found') unless @current_page
    end

    delegate :pages, :page_names, to: :framework

    def next_page
      pages.at(pages.index(current_page) + 1).tap do |page|
        if page.is_a?(Wizardry::Pages::CompletionPage)
          # do finished callback
        end
      end
    end
  end
end
