dep "legacy users removed" do
  requires %w( sync shutdown halt games gopher ftp lp ).map { |u|
    "#{u}.legacy_user"
  }
end

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

dep "sync.legacy_user"
dep "shutdown.legacy_user"
dep "halt.legacy_user"
dep "games.legacy_user"
dep "gopher.legacy_user"
dep "ftp.legacy_user"
dep "lp.legacy_user"
