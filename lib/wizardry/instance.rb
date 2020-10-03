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

    def next_page
      next_branch_page || next_trunk_page
    end

  private

    def next_branch_page
      current_page.next_pages.detect do |page|
        page.condition.blank? || page.condition.call(object)
      end
    end

    # if the branch ends continue along the trunk from
    # where we left off
    def next_trunk_page
      current_page_index = framework.pages.index(current_page)

      framework.pages.detect.with_index do |p, i|
        next if p.branch?

        i > current_page_index
      end
    end
  end
end
