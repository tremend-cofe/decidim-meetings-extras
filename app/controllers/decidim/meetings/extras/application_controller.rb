module Decidim
  module Meetings
    module Extras
      class ApplicationController < ActionController::Base
        protect_from_forgery with: :exception
      end
    end
  end
end
