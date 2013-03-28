dep 'mysql access' do
  requires 'existing mysql db'
  define_var :db_user, :default => :username
  define_var :db_host, :default => 'localhost'
  met? { mysql "use #{var(:db_name)}", var(:db_user) }
  meet { mysql %Q{GRANT ALL PRIVILEGES ON #{var :db_name}.* TO '#{var :db_user}'@'#{var :db_host}' IDENTIFIED BY '#{var :db_password}'} }
end

dep 'existing mysql db' do
  requires 'mysql configured'
  met? { mysql("SHOW DATABASES").split("\n")[1..-1].any? {|l| /\b#{var :db_name}\b/ =~ l } }
  meet { mysql "CREATE DATABASE #{var :db_name}" }
end

dep 'mysql configured' do
  requires 'mysql root password'
end

dep 'mysql root password' do
  requires 'mysql.managed'
  met? {
    raw_shell("echo '\q' | mysql -u root").stderr["Access denied for user 'root'@'localhost' (using password: NO)"]
  }
  meet {
    mysql(%Q{GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY '#{var :db_admin_password}'}, 'root', false)
  }
end

dep 'mysql.managed' do
  installs {
    via :brew, "mysql"
    via :yum, %w( mysql mysql-devel )
  }
  provides 'mysql'
end
