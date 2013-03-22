dep "unused services disabled" do
  requires %w( netfs sendmail ).map { |d|
    "#{d}.disabled_service"
  }
end

dep "sendmail.disabled_service"
dep "netfs.disabled_service"
