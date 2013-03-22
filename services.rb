dep "unused services disabled" do
  requires %w( sendmail ).map { |d|
    "#{d}.disabled_service"
  }
end

dep "sendmail.disabled_service"
