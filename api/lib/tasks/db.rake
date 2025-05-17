OUTPUT_FILE = "#{__dir__}/../../db/dump.tar"

namespace :db do
  task restore_from_supabase: :environment do
    supabase_url = "postgresql://postgres.lubihovnuywjcqxynowk:5684772667%23Supabase@aws-0-eu-west-3.pooler.supabase.com:5432/postgres"

    puts "Dumping supabase database"
    `pg_dump #{supabase_url} -f #{OUTPUT_FILE} -F tar`

    puts "preparing local database"
    Rake::Task["db:drop"].invoke
    Rake::Task["db:create"].invoke
    Rake::Task["db:schema:load"].invoke

    puts "Restoring local database"
    `pg_restore #{OUTPUT_FILE} -d api_development -F tar -U joenn`

    `rm -rf #{OUTPUT_FILE}`
  end
end
