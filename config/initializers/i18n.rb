Rails.application.config do |config|
  config.i18n.available_locales = [:en]
  config.i18n.default_locale = :en

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation cannot be found).
  config.i18n.fallbacks = !(Rails.env.development? || Rails.env.test?)
end
