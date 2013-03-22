meta :legacy_user do
  accepts_value_for :username, :basename
  template {
    met? {
      !"/etc/passwd".p.grep(/^#{username}\:/)
    }
    meet {
      log_shell "Removing user: #{username}", "userdel #{username}"
    }
  }
end
