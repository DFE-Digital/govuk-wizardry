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
    form_for(@wizard.object, url: send(@wizard.framework.update_path_helper, page: @wizard.current_page.name), method: :patch, builder: GOVUKDesignSystemFormBuilder::FormBuilder) do |f|
      capture do
        concat f.govuk_error_summary

        @wizard.current_page.questions.map do |q|
          concat f.send(q.form_method, q.name, *q.extra_args)
        end

        concat f.govuk_submit
      end
    end
  end

  def render_check_your_answers
    safe_join([
      tag.h1('Check your answers'),

      tag.p do
        ["Add a partial called", tag.code(%(_check_your_answers.html.erb)), "to override this message"].join(" ").html_safe
      end
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
end

ActiveSupport.on_load(:action_view) { include WizardryHelper }
