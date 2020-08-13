require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Fakeinst
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    config.autoload_paths += %W(#{config.root}/lib)

    # devise日本語化
    config.i18n.default_locale = :ja
    # タイムゾーンの変更
    config.time_zone = 'Asia/Tokyo'

    config.action_view.embed_authenticity_token_in_remote_forms = true

    # herokuでのアセットパイプライン用の設定
    config.assets.initialize_on_precompile = false
  end
end
