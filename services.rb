dep "unused services disabled" do
  requires %w( netfs sendmail ).map { |d|
    "#{d}.disabled_service"
  }
end

meta :disabled_service do
  accepts_value_for :service_name
  template {
    met? {
      shell("service #{service_name} status")[/inactive \(dead\)\b/]
    }
    meet {
      log_shell "Turning off #{service_name}", "service #{service_name} stop"
    }
  }
end

dep "sendmail.disabled_service"
dep "netfs.disabled_service"
