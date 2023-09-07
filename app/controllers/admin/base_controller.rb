class Admin::BaseController < ApplicationController
  layout "layouts/application_admin"
  included FootballPitchesHelper
end
