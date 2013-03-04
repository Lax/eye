
#DataMapper::Logger.new($stdout, :debug)
DataMapper::Model.raise_on_save_failure = true
DataMapper::Property::String.length(255)

if ENV['VCAP_SERVICES'].nil?
  DataMapper.setup(:default, ENV['DATABASE_URL'] || 'sqlite::memory:')
else
  require 'json'
  svcs = JSON.parse ENV['VCAP_SERVICES']

  if postgresql = svcs.detect { |k,v| k =~ /^postgresql/ }
    creds = postgresql.last.first['credentials']
    user, pass, host, name = %w(user password host name).map { |key| creds[key] }
    DataMapper.setup(:default, "postgres://#{user}:#{pass}@#{host}/#{name}")
  elsif mysql = svcs.detect { |k,v| k =~ /^mysql/ }
    creds = mysql.last.first['credentials']
    user, pass, host, name = %w(user password host name).map { |key| creds[key] }
    DataMapper.setup(:default, "mysql://#{user}:#{pass}@#{host}/#{name}")
  else
  end
end

class User
	include DataMapper::Resource

        property :id,   Serial
        property :name, String
        property :description, Text
        property :created_at, DateTime
end

DataMapper.finalize
DataMapper.auto_upgrade!
