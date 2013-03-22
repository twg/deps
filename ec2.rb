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
    "which.bin",
    "selinux disabled",
    "legacy users removed",
    "update.task",
    "ruby",
    "rubygems",
    "packages",
    "v8.lib",
    "v8 headers.lib",
    "web directory",
    "login fixed",
    "version etc",
  ]
end

# Required because the standard babushka script doesn't call yum update
dep "update.task" do
  log_shell "Update packages", "yum update -y"
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
  installs "v8"
end

dep "v8 headers.lib" do
  installs "v8-devel"
end

dep "web directory" do
  #see if it is attached with:
  #
  #$ sudo fdisk -l
  #=> Disk /dev/xvdf: 10.7 GB, 10737418240 bytes
  #
  #Format it
  #$ sudo mkfs -t ext4 /dev/xvdf
  #
  #Create dir where it will be mounted:
  #$ mkdir /web
  #
  #That's it you can mount it:
  #$ sudo mount /dev/xvdf /mnt
  #
  #Check if it has been mounted correctly with:
  #$ mount -l
  #/dev/xvdf on /mnt type ext4 (rw)
  #
  #Make it to mount automatically on system start
  #$ sudo vim  /etc/fstab
  #
  #and add this:
  #/dev/xvdf       /mnt1   auto    defaults,nobootwait     0       0
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
