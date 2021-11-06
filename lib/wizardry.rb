require "wizardry/engine"
require "wizardry/railtie"
require "wizardry/framework"
require "wizardry/instance"

require "wizardry/pages/page"
require "wizardry/pages/question_page"
require "wizardry/pages/check_your_answers_page"
require "wizardry/pages/completion_page"

require "wizardry/questions/answer"
require "wizardry/questions/short_answer"
require "wizardry/questions/long_answer"
require "wizardry/questions/radios"
require "wizardry/questions/telephone_number"
require "wizardry/questions/email_address"
require "wizardry/questions/date"
require "wizardry/questions/hidden"

require "wizardry/routing/next_page"

require "govuk_design_system_formbuilder"
require "govuk/components"

module Wizardry
  extend ActiveSupport::Concern

  class AlreadyCompletedError < StandardError; end

  class_methods do
    def wizard(...)
      define_method(:wizard) do
        @framework ||= Wizardry::Framework.new(...)
      end
    end
  end

  included do
    before_action :setup_wizard, :check_wizard

    def edit
      Rails.logger.debug("🧙 Running before_edit callback")
      @wizard.current_page.before_edit!(@wizard.object)
    end

    def update
      Rails.logger.debug("🧙 Object valid, saving and moving on")
      @wizard.object.assign_attributes(object_params.merge(last_completed_step_params))

      Rails.logger.debug("🧙 Running before_update callback")
      @wizard.current_page.before_update!(@wizard.object)

      if @wizard.object.valid?(@wizard.current_page.name)
        @wizard.object.transaction do
          @wizard.object.save!
          Rails.logger.debug("🧙 Object saved, trying after_update callback")

          @wizard.current_page.after_update!(@wizard.object)
          Rails.logger.debug("🧙 Object saved and callbacks run, moving on")

          finish if @wizard.complete?
        end

        redirect_to send(@wizard.framework.edit_path_helper, @wizard.next_page.name.to_s.dasherize)
      else
        Rails.logger.debug("🧙 Object not valid, try again")

        render :edit
      end
    end

  private

    def finish
      Rails.logger.debug("🧙 Wizard complete, finishing off")

      finalize_object!
      clear_identifier!
    end

    def finalize_object!(finalize_method: :finalize!)
      Rails.logger.debug("🧙 Trying to finalize object")

      if @wizard.object.respond_to?(finalize_method)
        Rails.logger.debug("🧙 Object has #{finalize_method} method - calling it")

        @wizard.object.send(finalize_method)
      else
        Rails.logger.warn("🧙 Wizard object has no #{finalize_method} method")
      end
    end

    def check_wizard
      @wizard.ensure_not_complete unless @wizard.current_page.is_a?(Wizardry::Pages::CompletionPage)
    end

    def setup_wizard
      Rails.logger.debug("🧙 Finding or initialising #{wizard.class_name} with '#{identifier}'")

      object = wizard.class_name.constantize.find_or_initialize_by(identifier: identifier)

      Rails.logger.debug("🧙 Initialising the wizard 🪄")

      @wizard = Wizardry::Instance.new(current_page: params[:page].underscore, object: object, framework: @framework)
    end

    def object_params
      param_key = @wizard.framework.class_name.constantize.model_name.param_key

      params.require(param_key).permit(@wizard.current_page.question_names)
    rescue ActionController::ParameterMissing
      { param_key => last_completed_step_params }
    end

    def last_completed_step_params
      { last_completed_step: @wizard.current_page.name }
    end

    def identifier
      cookies.fetch(wizard.cookie_name) { set_identifier! }
    end

    def set_identifier!
      identifier = SecureRandom.uuid

      Rails.logger.debug("🧙 Setting cookie #{identifier}")

      cookies[wizard.cookie_name] = identifier
    end

    def clear_identifier!
      Rails.logger.debug("🧙 Clearing cookie")

      cookies.delete(wizard.cookie_name)
    end
  end
end
