# This set of deps is currently Fedora-specific
#
# TODO:
# export RAILS_ENV=production or staging
# export RACK_ENV=production or staging
# based on conditional
#
#
dep "ec2" do
  # setup {
  #   unmeetable! "This dep has to be run as root." unless shell('whoami') == 'root'
  # }
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
    "rbenv",
    "v8.lib"
  ]
end

# Required because the standard babushka script doesn't call yum update
dep "update.task" do
  log_shell "Update packages", "yum update -y"
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

dep "v8.lib" do
  installs %w( libv8 )
end
