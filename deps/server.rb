# This set of deps is currently Fedora-specific
#
# TODO:
# export RAILS_ENV=production or staging
# export RACK_ENV=production or staging
#
# install readline zlib v8lib
#
dep "server" do
  on :linux do
    setup {
      unmeetable! "This dep has to be run as root." unless shell('whoami') == 'root'
    }
  end
  requires [
    "selinux disabled",
    "daemons disabled",
    "unused services disabled",
    "rubies",
    "legacy users deleted",
    "yum update",
    "build tools",
    "standard.bin",
    "ntpdate",
    "ntpd",
    "ruby",
    "rubygems",
    "symlink web directory",
    "version etc",
    "packages"
  ]
end

dep "daemon disabled", :daemon_name, :for => :linux do
  met? {
    shell("systemctl is-enabled #{daemon_name}.service")[/enabled/]
  }
  meet {
    log_shell "#{daemon_name} disabled", "chkconfig --level 3 #{daemon_name} off"
  }
end

dep "daemons disabled" do
  %w( netfs nfslock rpcbind rpcgssd rpcidmapd sendmail ).each do |daemon|
    requires "daemon disabled".with(:daemon_name => daemon)
  end
end

dep "unused service disabled", :service_name, :for => :linux do
  met? {
    shell("service #{service_name} status")[/inactive \(dead\)\b/]
  }
  meet {
    log_shell "Turning off #{service_name}", "service #{service_name} stop"
  }
end

dep "unused services disabled", :for => :linux do
  %w( sendmail netfs ).each do |service|
    requires "unused service disabled".with(:service_name => service)
  end
end

dep "legacy user deleted", :username do
  met? {
    !"/etc/passwd".p.grep(/^#{username}\:/)
  }
  meet {
    "userdel #{username}"
  }
end

dep "legacy users deleted", :for => :linux do
  %w( sync shutdown halt games gopher ftp lp ).each do |user|
    requires "legacy user deleted".with(:username => user)
  end
end

dep "yum update", :for => :linux do
  meet {
    log_shell "Update packages", "yum update -y"
  }
end

dep "libs" do
  package_list = %w( readline )
  package_list.each do |lib|
    package_list << lib
    package_list << "#{lib}-devel"
  end
  package_list += %w( ImageMagick-devel v8-devel )
end

dep "ntpdate", :for => :linux do
  met? {
    shell("systemctl is-enabled ntpdate.service")[/enabled/]
  }
  meet {
    log_shell "NTP date service enabled", "systemctl enable ntpdate.service"
  }
end

dep "ntpd", :for => :linux do
  met? {
    shell("systemctl is-enabled ntpd.service")[/enabled/]
  }
  meet {
    log_shell "NTP daemon service started", "systemctl start ntpd.service"
  }
end

dep "version etc", :for => :linux do
  requires "git.bin"
  requires "perl.bin"
  commands = [
    "cd /etc",
    "git init",
    "git add .",
    "git config user.name 'System Admin'",
    "git config user.email 'admin@twg.ca'",
    "git commit -m 'Initial configuration'"
  ].join(" && ")
  log_shell "Version the /etc directory", commands
end

dep "symlink web directory", :for => :linux do
  met? {
    shell?("ls / | grep web")[/var\/www/]
  }
  meet {
    log_shell "Linked /web to /var/www", "ln -s /var/www /web"
  }
end

dep "root login disabled" do
  requires "perl.bin"
  met? {
    "/etc/ssh/sshd_config".p.grep(/^PermitRootLogin no/)
  }
  meet {
    shell "perl -pi -e 's/\#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config"
  }
end

dep "password authentication disabled" do
  met? {
    "/etc/ssh/sshd_config".p.grep(/^PasswordAuthentication no/)
  }
  meet {
    shell "perl -pi -e 's/^PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config"
  }
end

dep "login fixed" do
  requires "root login disabled"
  requires "password authentication disabled"
  after {
    shell "service sshd restart"
  }
end
