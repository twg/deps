meta :disabled_daemon do
  accepts_value_for :daemon_name, :basename
  template {
    met? {
      shell("systemctl is-enabled #{daemon_name}.service")[/disabled/]
    }
    meet {
      log_shell "Disabling #{daemon_name}", "chkconfig --level 3 #{daemon_name} off"
    }
  }
end
