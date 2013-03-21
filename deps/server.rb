# This set of deps is currently Fedora-specific
#
# TODO:
# export RAILS_ENV=production or staging
# export RACK_ENV=production or staging
#
# useradd deploy
#
# usermod -G wheel deploy
#
# chown -R deploy:deploy /web
#
# perl -pi -e 's/\#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
# perl -pi -e 's/^PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
# service sshd restart
#
dep "server" do
  requires [
    "selinux disabled",
    "daemons disabled",
    "unused services disabled",
    "rubies",
    "legacy users deleted",
    "yum update",
    "packages",
    "ntpdate",
    "ntpd",
    "ruby",
    "rubygems",
    "version etc"
  ]
end

dep "daemon disabled", :daemon_name do
  on :linux do
    met? {
      shell("systemctl is-enabled #{daemon_name}.service")[/enabled/]
    }
  end
  meet {
    log_shell "#{daemon_name} disabled", "chkconfig --level 3 #{daemon_name} off"
  }
end

dep "daemons disabled" do
  daemons = [
    "netfs",
    "nfslock",
    "rpcbind",
    "rpcgssd",
    "rpcidmapd",
    "sendmail"
  ].each do |daemon|
    requires "daemon disabled".with(:daemon_name => daemon)
  end
end

dep "unused service disabled", :service_name do
  on :linux do
    met? {
      shell("service #{service_name} status")[/inactive \(dead\)\b/]
    }
  end
  meet {
    log_shell "Turning off #{service_name}", "service #{service_name} stop"
  }
end

dep "unused services disabled" do
  legacy_users = [ "sendmail", "netfs" ].each do |service|
    requires "unused service disabled".with(:service_name => service)
  end
end

dep "legacy user deleted", :username do
  met? {
    !"/etc/passwd".p.grep(/^#{Regexp.quote(username)}\:/)
  }
  meet {
    "userdel #{username}"
  }
end

dep "legacy users deleted" do
  legacy_users = [
    "sync",
    "shutdown",
    "halt",
    "games",
    "gopher",
    "ftp",
    "lp"
  ].each do |user|
    requires "legacy user deleted".with(:username => user)
  end
end

dep "yum update" do
  meet {
    log_shell "Update packages", "yum update -y"
  }
end

dep "packages", :template => "bin" do
  package_list = %w( man nmap bind-util make patch gcc gcc-c++ autoconf automake libtool scons ntp )
  %w( zblib readline openssl libxml2 libxslt ).each do |lib|
    package_list << lib
    package_list << "#{lib}-devel"
  end
  package_list += %w( ImageMagick-devel v8-devel )
  installs {
    via :yum, package_list
  }
  provides package_list
end

dep "ntpdate" do
  on :linux do
    met? {
      shell("systemctl is-enabled ntpdate.service")[/enabled/]
    }
    meet {
      log_shell "NTP date service enabled", "systemctl enable ntpdate.service"
    }
  end
end

dep "ntpd" do
  on :linux do
    met? {
      shell("systemctl is-enabled ntpd.service")[/enabled/]
    }
    meet {
      log_shell "NTP daemon service started", "systemctl start ntpd.service"
    }
  end
end

dep "version etc" do
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

dep "symlink web directory" do
  met? {
    shell("ls / | grep web")[/var\/www/]
  }
  meet {
    log_shell "Linked /web to /var/www", "ln -s /var/www /web"
  }
end
