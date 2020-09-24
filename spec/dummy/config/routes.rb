Rails.application.routes.draw do
  get %(rating/:page), to: %(ratings#edit), as: :ratings_page
  patch %(rating/:page), to: %(ratings#update), as: :ratings
end
