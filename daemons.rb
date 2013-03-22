dep "daemons disabled" do
  requires %w(
    netfs
    nfslock
    rpcbind
    rpcgssd
    rpcidmapd
    sendmail
  ).map { |d| "#{d}.disabled_daemon" }
end

dep "netfs.disabled_daemon"
dep "nfslock.disabled_daemon"
dep "rpcbind.disabled_daemon"
dep "rpcgssd.disabled_daemon"
dep "rpcidmapd.disabled_daemon"
dep "sendmail.disabled_daemon"
