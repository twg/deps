dep "daemons disabled" do
  requires %w(
    sendmail
  ).map { |d| "#{d}.disabled_daemon" }
end

dep "sendmail.disabled_daemon"
