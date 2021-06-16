# frozen_string_literal: true

namespace :decidim do
  namespace :demographics do
    # task upgrade: [:choose_target_plugins, :"railties:install:migrations"]

    desc "Setup environment so that only decidim migrations are installed."
    task :choose_target_plugins do
      ENV["FROM"] += ",decidim_demographics"
    end
  end
end
Rake::Task["railties:install:migrations"].enhance(["decidim:demographics:choose_target_plugins"])
