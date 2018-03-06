# VERY Helpful:
# http://iain.nl/testing-activerecord-in-isolation
require 'pry'

require 'active_record'
require 'support/active_record'
# require 'rspec/rails/extensions/active_record/base'
require 'active_support/buffered_logger'

ActiveRecord::Base.establish_connection(
  adapter: 'mysql2', database: 'arbitrary',
  encoding: 'utf8', pool: 5,
  username: 'root', password: 'root',
  host: '127.0.0.1', port: 3306
)

RSpec.configure do |config|
  config.before(:suite) do
    begin
      ActiveRecord::Migration.drop_table :posts
    rescue StandardError
      nil
    end
    begin
      ActiveRecord::Migration.drop_table :comments
    rescue StandardError
      nil
    end
    ActiveRecord::Migration.create_table :posts do |t|
      t.string :name
      t.timestamps
    end
    ActiveRecord::Migration.create_table :comments do |t|
      t.integer :post_id
      t.string :content
      t.timestamps
    end
  end

  config.around do |example|
    ActiveRecord::Base.transaction do
      example.run
      raise ActiveRecord::Rollback
    end
  end

  config.after(:suite) do
    ActiveRecord::Migration.drop_table :posts
    ActiveRecord::Migration.drop_table :comments
  end
end
