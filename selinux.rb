dep "selinux disabled", :for => :linux do
  requires "perl.bin"
  meet {
    log_shell "Disable selinux", "perl -pi -e 's/enforcing/disabled/' /etc/selinux/config"
  }
end
