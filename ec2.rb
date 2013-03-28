# This set of deps is currently Fedora-specific
#
# TODO:
# 1. export RAILS_ENV=production or staging
#    export RACK_ENV=production or staging
#    (based on conditional)
#
# 2. Create deploy user w/keys
#
# 3. add deploy key to two-deploy github user (if possible to automate)


# This script is meant to be run as root, and then use the deploy_user script
# with the newly created deploy user.
dep "ec2" do
  setup {
    unmeetable! "This dep has to be run as root." unless shell('whoami') == 'root'
  }
  requires [
    "update.task",
    "utilities",
    "libraries",
    "selinux disabled",
    "legacy users removed",
    "ruby",
    "dev tools",
    "rubygems",
    "web directory",
    "login fixed",
    "postgres.managed",
    "mysql.managed",
    "version etc",
    "deploy user"
  ]
end

# Required because the standard babushka script doesn't call yum update
dep "update.task" do
  log_shell "Updating packages", "yum update -y"
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

dep "version etc" do
  requires "git.bin"
  requires "perl.bin"
  met? {
    "/etc/.git".p.exists?
  }
  meet {
    commands = [
      "cd /etc",
      "git init",
      "git add .",
      "git config user.name 'System Admin'",
      "git config user.email 'admin@twg.ca'",
      "git commit -m 'Initial configuration'"
    ].join(" && ")
    log_shell "Version the /etc directory", commands
  }
end
