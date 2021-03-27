class ApplicationController < ActionController::Base
  def mysql_connect
    require 'mysql2'
    Mysql2::Client.new(host: :'db', username: :'root', password: ENV['MYSQL_ROOT_PASSWORD'], database: :'Multi_0_Design_development')
  end
end
