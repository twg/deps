dep "selinux disabled" do
  requires "perl"
  meet {
    log_shell "Disable selinux", "perl -pi -e 's/enforcing/disabled/' /etc/selinux/config"
  }
end
