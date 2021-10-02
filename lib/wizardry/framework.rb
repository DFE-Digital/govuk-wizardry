module Wizardry
  # Framework holds data on how the wizard itself is constructed. It'll
  # be the same for every instance
  class Framework
    attr_accessor :name, :pages, :class_name, :edit_path_helper, :update_path_helper

    def initialize(name:, pages:, class_name:, edit_path_helper:, update_path_helper:)
      @name               = name
      @pages              = setup_pages(pages)
      @class_name         = class_name
      @edit_path_helper   = edit_path_helper
      @update_path_helper = update_path_helper

      page_sense_check
    end

    def cookie_name
      %(#{@name}-wizard)
    end

    def page_names
      pages.map(&:name)
    end

    def trunk_pages
      pages.reject(&:branch?)
    end

    def branch_pages
      pages.select(&:branch?)
    end

    def page(name)
      pages.detect { |p| p.name == name }
    end

  private

    def page_sense_check
      # should have no more than one check your answers page
      pages.select { |page| page.is_a?(Wizardry::Pages::CheckYourAnswersPage) }.tap do |check_your_answers_pages|
        Rails.logger.warn("🧙 More than one check your answers page detected") if check_your_answers_pages.size > 1
      end

      # should have no more than one completion page
      pages.select { |page| page.is_a?(Wizardry::Pages::CompletionPage) }.tap do |completion_pages|
        Rails.logger.warn("🧙 More than one completion page detected") if completion_pages.size > 1
      end
    end

    def setup_pages(pages)
      pages.map { |page| [page, page.pages.each(&:branch!)].select(&:presence) }.flatten
    end
  end
end
