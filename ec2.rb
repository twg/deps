# This set of deps is currently Fedora-specific
#
# TODO:
# 1. export RAILS_ENV=production or staging
#    export RACK_ENV=production or staging
#    (based on conditional)
#
# 2. mount /web directory, which is a separate EBS volume
#
# 3. Create deploy user w/keys
#
# 4. add deploy key to two-deploy github user (if possible to automate)


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

dep "web directory" do
  requires [
    "web drive available",
    "web drive formatted",
    "web directory created",
    "web drive mounted",
    "web drive starts up"
  ]
end

dep "web directory created" do
  met? {
    "/web".p.exists?
  }
  meet {
    "/web".p.create
  }
end

dep "web drive mounted" do
  met? {
    shell("mount -l")[/web/]
  }
  meet {
    log_shell "Mounting /web", "mount /dev/xvdf /web"
  }
end

dep "web drive available" do
  met? {
    shell("fdisk -l")[/dev\/xvdf/]
  }
  meet {
    shell("echo 'web drive is not available!")
  }
end

dep "web drive formatted" do
  met? {
    shell("mount -l")[/ext4/]
  }
  meet {
    shell("mkfs -t ext4 /dev/xvdf")
  }
end

dep "web drive starts up" do
  met? {
    "/etc/fstab".p.grep(/web1/)
  }
  meet {
    "/etc/fstab".p.append("/dev/xvdf       /web1   auto    defaults,nobootwait     0       0")
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
