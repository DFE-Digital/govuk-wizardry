module WizardryHelper
  def wizardry_content(w)
    case w.current_page
    when Wizardry::Pages::QuestionPage
      render_form(w)
    when Wizardry::Pages::CheckYourAnswersPage
      safe_join([render_check_your_answers(w), render_form(w)])
    when Wizardry::Pages::CompletionPage
      render_completion(w)
    end
  end

private

  def render_form(w)
    capture do
      try_partial(w, 'page') do
        wizard_form(w) do |f|
          try_partial(w, 'form', locals: { f: f }) do
            concat(f.govuk_error_summary)

            w.current_page.questions.map do |q|
              concat(f.send(q.form_method, q.name, *q.extra_args, **q.extra_kwargs))
            end

            concat(f.govuk_submit)
          end
        end
      end
    end
  end

  def render_check_your_answers(w)
    capture do
      try_partial(w, 'page') do
        safe_join(
          [
            render(GovukComponent::SummaryListComponent.new) do |summary_list|
              w.route.each do |page|
                page.questions.each do |question|
                  summary_list.row do |sl|
                    sl.key(text: check_your_answers_key(w.object.class.name, question.name))
                    sl.value(text: w.object.send(question.name))
                    sl.action(href: send(w.framework.edit_path_helper, page.name))
                  end
                end
              end
            end
          ]
        )
      end
    end
  end

  def render_completion(w)
    capture do
      try_partial(w, 'page') do
        safe_join(
          [
            tag.h1('Completed'),

            tag.p do
              [
                'Add a partial called',
                tag.code(%(_completion.html.erb)),
                'to override this message'
              ].join(' ').html_safe
            end
          ]
        )
      end
    end
  end

  def wizard_form(w, turbo_frame_id: 'wizardry-form', &block)
    turbo_frame_tag(turbo_frame_id) do
      safe_join(
        [
          form_for(
            w.object,
            url: send(
              w.framework.update_path_helper,
              page: w.current_page.name
            ),
            method: :patch,
            builder: GOVUKDesignSystemFormBuilder::FormBuilder,
            &block
          )
        ]
      )
    end
  end

  def try_partial(w, section, locals: {}, &block)
    if lookup_context.template_exists?(partial_file_path(w, section))
      Rails.logger.debug("🧙 Page partial #{partial_file_path(w, section)} found; rendering entire page")

      concat(render(partial: partial_render_path(w, section), locals: locals))
    else
      Rails.logger.debug('🧙 No overriding form partial found; automatically building form')

      block.call
    end
  end

  def check_your_answers_key(class_name, question_name)
    I18n.t!("helpers.legend.#{class_name.underscore}.#{question_name}")
  rescue I18n::MissingTranslationData
    I18n.t("helpers.label.#{class_name.underscore}.#{question_name}")
  end

  def partial_file_path(w, suffix)
    "#{w.framework.name}/_#{w.current_page.name}_#{suffix}"
  end

  def partial_render_path(w, suffix)
    "#{w.framework.name}/#{w.current_page.name}_#{suffix}"
  end
end

ActiveSupport.on_load(:action_view) { include WizardryHelper }
