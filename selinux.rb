dep "selinux disabled", :for => :linux do
  requires "perl.bin"
  # TODO: add met? section
  meet {
    log_shell "Disable selinux", "perl -pi -e 's/enforcing/disabled/' /etc/selinux/config"
  }
end
