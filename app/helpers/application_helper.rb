module ApplicationHelper
  include Pagy::Frontend

  def render_star_rating rating
    full_star = content_tag(:i, "", class: "fas fa-star")
    half_star = content_tag(:i, "", class: "fas fa-star-half-alt")
    empty_star = content_tag(:i, "", class: "far fa-star")
    full_stars = rating.floor
    has_half_star = rating - full_stars >= 0.5
    stars = (full_star * full_stars).concat(half_star) if has_half_star
    stars = full_star * full_stars unless has_half_star
    remaining_stars = empty_star * (5 - full_stars - (has_half_star ? 1 : 0))
    stars.concat(remaining_stars)
  end
end