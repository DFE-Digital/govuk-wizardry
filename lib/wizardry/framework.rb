module Wizardry
  # Framework holds data on how the wizard itself is constructed. It'll
  # be the same for every instance
  class Framework
    attr_accessor :name, :pages, :class_name, :edit_path_helper, :update_path_helper

    def initialize(name:, pages:, class_name:, edit_path_helper:, update_path_helper:)
      @name               = name
      @pages              = pages
      @class_name         = class_name
      @edit_path_helper   = edit_path_helper
      @update_path_helper = update_path_helper
    end

    def cookie_name
      %(#{@name}-wizard)
    end

    def page_names
      pages.map(&:name)
    end
  end
end
