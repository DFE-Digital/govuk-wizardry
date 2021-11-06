module Wizardry
  # Instance holds data specific to this page/response
  class Instance
    attr_accessor :current_page, :object, :framework

    def initialize(current_page:, object:, framework:)
      @object       = object
      @framework    = framework
      @current_page = @framework.pages.detect { |p| p.name == current_page.to_sym }

      raise(ActionController::RoutingError, %(Wizard page #{current_page} not found)) unless @current_page
    end

    def next_page(page = current_page)
      next_branch_page(page) || next_trunk_page(page)
    end

    # find all the pages we've visited on our way to
    # the current page
    def route(from = framework.pages.first)
      @route ||= route!(from)
    end

    def route!(from = framework.pages.first)
      page = from

      @route = [].tap do |completed|
        until page == current_page
          completed << page

          page = next_page(page)
        end
      end
    end

    def valid_so_far?
      route.all? { |complete_page| object.valid?(complete_page.name) }
    end

    # check this wizard hasn't already been completed using the
    # object's :completion_flag
    def ensure_not_complete
      raise Wizardry::AlreadyCompletedError if complete?
    end

    def complete?
      !!object.send(framework.completion_flag)
    end

  private

    def next_branch_page(page)
      next_page = page.next_pages.detect do |p|
        p.condition.blank? || p.condition.call(object)
      end

      return unless next_page

      framework.page(next_page.name)
    end

    # if the branch ends continue along the trunk from
    # where we left off
    def next_trunk_page(page)
      page_index = framework.pages.index(page)

      framework.pages.detect.with_index do |p, i|
        next if p.branch?

        i > page_index
      end
    end
  end
end
