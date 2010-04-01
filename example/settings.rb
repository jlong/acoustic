# Database
gem 'activerecord', '>=2.3.2'

ActiveRecord::Base.establish_connection(
  :adapter  => "mysql",
  :username => "root",
  :database => "acoustic_example"
)

# Additional Load Paths
additional_load_paths = []