require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CatalogoFilmes
  class Application < Rails::Application

    config.load_defaults 8.0
    config.autoload_lib(ignore: %w[assets tasks])

    config.i18n.available_locales = [ :en, :'pt-BR' ]
    config.i18n.default_locale = :en

    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
  end
end
