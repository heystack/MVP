Mvp::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_view.debug_rjs             = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin
  
  # Action Mailer settings for StkUp
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    :address              => "smtp.gmail.com",
    :port                 => 587,
    :domain               => 'mail.stkup.com',
    :user_name            => 'feedback@stkup.com',
    :password             => 'may18stkup',
    :authentication       => 'plain',
    :enable_starttls_auto => true  }
  config.action_mailer.asset_host = "parenting-mvp.heroku.com"

  # amazonses = AmazonSes::Mailer.new(:secret_key => 'rW8Pb+EyMz44dhblptIHRmQ8tRU/LvJ9yRufihnR', :access_key => 'AKIAJYA3KQ32M2TNRERQ')
  # config.action_mailer.delivery_method = amazonses

  # config.action_mailer.delivery_method = :ses

end

