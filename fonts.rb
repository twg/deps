dep "terminus.font", :for => :osx do
  met? {
    "~/Library/Fonts/TerminusMedium-4.38.ttf".p.exists?
    # TODO: check it's installed
  }
  meet {
    source "http://downloads.sourceforge.net/project/terminus-font/terminus-font-4.38/terminus-font-4.38.tar.gz?r=http%3A%2F%2Fterminus-font.sourceforge.net%2F&ts=1364040681&use_mirror=hivelocity"
  }
end
