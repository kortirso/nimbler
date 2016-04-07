## Nimbler

Nimbler application deployed at DigitalOcean - <http://46.101.217.59:3006>.
You can visit it and get data from google search.

#### To install application you need run commands:

1. _git clone https://github.com/kortirso/nimbler.git_.
2. _cd nimbler_.
3. _bundle install_.
4. rename config/application.yml.example to config/application.yml and fill with your secrets.
5. _rake db:create_.
6. _rake db:schema:load_.

#### To launch application:

1. In project folder run _rails s_.
2. In project folder run _redis-server_.
3. In project folder run _sidekiq_.
4. Open http://localhost:3000.
