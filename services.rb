dep "unused services disabled" do
  requires %w( netfs sendmail ).map { |d|
    "#{d}.disabled_service"
  }
end

meta :disabled_service do
  accepts_value_for :service_name, :basename
  template {
    met? {
      shell("systemctl status #{service_name}.service")[/inactive \(dead\)\b/]
    }
    meet {
      log_shell "Turning off #{service_name}", "systemctl stop #{service_name}.service"
    }
  }
end

dep "sendmail.disabled_service"
dep "netfs.disabled_service"
