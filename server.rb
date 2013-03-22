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
    "legacy users removed",
    "update.task",
    "ruby",
    "rubygems",
    "version etc",
    "packages",
    "rbenv"
  ]
end

dep "update.task", :for => :linux do
  log_shell "Update packages", "yum update -y"
end

dep "libs" do
  package_list = %w( readline )
  package_list.each do |lib|
    package_list << lib
    package_list << "#{lib}-devel"
  end
  package_list += %w( ImageMagick-devel v8-devel )
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
