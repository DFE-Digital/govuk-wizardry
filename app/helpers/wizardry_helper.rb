module WizardryHelper
  def wizardry_form
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
end

ActiveSupport.on_load(:action_view) { include WizardryHelper }
