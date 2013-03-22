dep "daemons disabled" do
  requires %w( netfs nfslock rpcbind rpcgssd rpcidmapd sendmail ).map { |d|
    "#{d}.disabled_daemon"
  }
end

meta :disabled_daemon do
  accepts_value_for :daemon_name, :basename
  template {
    met? {
      shell("systemctl is-enabled #{daemon_name}.service")[/disabled/]
    }
    meet {
      log_shell "#{daemon_name} disabled", "chkconfig --level 3 #{daemon_name} off"
    }
  }
end

dep "netfs.disabled_daemon"
dep "nfslock.disabled_daemon"
dep "rpcbind.disabled_daemon"
dep "rpcgssd.disabled_daemon"
dep "rpcidmapd.disabled_daemon"
dep "sendmail.disabled_daemon"
