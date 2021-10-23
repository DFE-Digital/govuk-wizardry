module ApplicationHelper
  # fake turbo_frame_tag so we don't need to pull in and configure all of Turbo
  # just to make the tests happy
  #
  # Turbo:         https://turbo.hotwired.dev/
  # Actual helper: https://github.com/hotwired/turbo-rails/blob/main/app/helpers/turbo/frames_helper.rb
  def turbo_frame_tag(id, &block)
    tag.turbo_frame_tag(id: id, &block)
  end
end
