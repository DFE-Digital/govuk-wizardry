module WizardryHelper
  def wizardry_content
    case @wizard.current_page
    when Wizardry::Pages::QuestionPage
      render_form
    when Wizardry::Pages::CheckYourAnswersPage
      safe_join([render_check_your_answers, render_form])
    when Wizardry::Pages::CompletionPage
      render_completion
    end
  end

private

  def render_form
    wizard_form do |f|
      capture do
        if lookup_context.template_exists?(partial_file_path)
          Rails.logger.warn("🧙 Partial #{partial_file_path} found; rendering")

          concat(render(partial: partial_render_path, locals: { f: f }))
        else
          Rails.logger.warn("🧙 No overriding partial found; rendering form")
          concat(f.govuk_error_summary)

          @wizard.current_page.questions.map do |q|
            concat(f.send(q.form_method, q.name, *q.extra_args, **q.extra_kwargs))
          end

          concat(f.govuk_submit)
        end
      end
    end
  end

  def partial_file_path(suffix: "form")
    "#{@wizard.framework.name}/_#{@wizard.current_page.name}_#{suffix}"
  end

  def partial_render_path(suffix: "form")
    "#{@wizard.framework.name}/#{@wizard.current_page.name}_#{suffix}"
  end

  def render_check_your_answers
    safe_join([
      render(GovukComponent::SummaryListComponent.new) do |summary_list|
        @wizard.route.each do |page|
          page.questions.each do |question|
            summary_list.row do |sl|
              sl.key(text: check_your_answers_key(@wizard.object.class.name, question.name))
              sl.value(text: @wizard.object.send(question.name))
              sl.action(href: send(@wizard.framework.edit_path_helper, page.name))
            end
          end
        end
      end,
    ])
  end

  def render_completion
    safe_join([
      tag.h1('Completed'),

      tag.p do
        ["Add a partial called", tag.code(%(_completion.html.erb)), "to override this message"].join(" ").html_safe
      end
    ])
  end

  def wizard_form(turbo_frame_id: "wizardry-form", &block)
    turbo_frame_tag(turbo_frame_id) do
      safe_join(
        [
          form_for(
            @wizard.object,
            url: send(
              @wizard.framework.update_path_helper,
              page: @wizard.current_page.name
            ),
            method: :patch,
            builder: GOVUKDesignSystemFormBuilder::FormBuilder,
            &block
          )
        ]
      )
    end
  end

  def check_your_answers_key(class_name, question_name)
    I18n.t!("helpers.legend.#{class_name.underscore}.#{question_name}")
  rescue I18n::MissingTranslationData
    I18n.t("helpers.label.#{class_name.underscore}.#{question_name}")
  end
end

ActiveSupport.on_load(:action_view) { include WizardryHelper }
