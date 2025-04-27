Rails.application.configure do
  config.active_job.queue_adapter = :good_job

  config.middleware.use Rack::MethodOverride
  config.middleware.use ActionDispatch::Flash
  config.middleware.use ActionDispatch::Cookies
  config.middleware.use ActionDispatch::Session::CookieStore

  config.good_job.execution_mode = Rails.env.test? ? :inline : :async
  config.good_job.preserve_job_records = false

  config.good_job.enable_cron = true
  config.good_job.cron = {
    steam_sync: {
      cron: "0 0 * * *",
      class: "Steam::SyncJob",
      description: "Fetching Steam for recently played games every day"
    },
  }
end
