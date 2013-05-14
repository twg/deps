# This set of deps is Fedora-specific
#
# TODO:
# 1. export RAILS_ENV=production or staging
#    export RACK_ENV=production or staging
#    (based on conditional)
#
# 2. Create deploy user w/keys
#
# 3. add deploy key to twg-deploy github user (if possible to automate)

dep "ec2" do
  setup {
    unmeetable! "This dep has to be run as root." unless shell('whoami') == 'root'
  }
  requires [
    "utilities",
    "libraries",
    "selinux disabled",
    "legacy users removed",
    "ruby",
    "build tools",
    "rubygems",
    "web directory",
    "deploy user",
    "login fixed",
    "postgres.managed",
    "mysql.managed",
    "version etc",
    "nodejs.lib"
  ]
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
    log_shell "Versioning the /etc directory", commands
  }
end
