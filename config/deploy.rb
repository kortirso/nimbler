# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'nimbler'
set :repo_url, 'git@github.com:kortirso/nimbler.git'

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/var/www/html/nimbler'
set :deploy_user, 'kortirso'

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/application.yml')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads')

namespace :deploy do
    desc 'Restart application'
    task :restart do
        on roles(:app), in: :sequence, wait: 5 do
            execute :touch, release_path.join('tmp/restart.txt')
        end
    end

    after :publishing, :restart
end

namespace :sphinx do
    desc 'Reindex sphinx'
    task :reindex do
        on roles(:app) do
            within release_path do
                with rails_env: :production do
                    execute :rake, 'ts:index'
                end
            end
        end
    end

    desc 'Stop sphinx'
    task :stop do
        on roles(:app) do
            within release_path do
                with rails_env: :production do
                    execute :rake, 'ts:stop'
                end
            end
        end
    end

    desc 'Start sphinx'
    task :start do
        on roles(:app) do
            within release_path do
                with rails_env: :production do
                    execute :rake, 'ts:start'
                end
            end
        end
    end
end

after 'deploy:restart', 'sphinx:reindex'
