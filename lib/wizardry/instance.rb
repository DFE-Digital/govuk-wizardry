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

    def next_page(page = current_page)
      next_branch_page(page) || next_trunk_page(page)
    end

    # find all the pages we've visited on our way to
    # the current page
    def route(page = framework.pages.first)
      [].tap do |completed|
        until page == current_page
          completed << page
          page = next_page(page)
        end
      end
    end

    def valid_so_far?
      route.all? { |complete_page| object.valid?(complete_page.name) }
    end

  private

    def next_branch_page(page)
      page.next_pages.detect do |page|
        page.condition.blank? || page.condition.call(object)
      end
    end

    # if the branch ends continue along the trunk from
    # where we left off
    def next_trunk_page(page)
      page_index = framework.pages.index(page)

      framework.pages.detect.with_index do |page, i|
        next if page.branch?

        i > page_index
      end
    end
  end
end
