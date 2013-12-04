dep "apps", :for => :osx do
  requires [
    "Sublime.app",
    "Firefox.app",
    "Google Chrome.app",
    "Postgres.app",
    "SQLEditor.app"
  ]
end

dep "Sublime.app" do
  source "http://c758482.r82.cf2.rackcdn.com/Sublime%20Text%202.0.1.dmg"
end

dep "Firefox.app" do
  source "https://download.mozilla.org/?product=firefox-19.0.2&os=osx&lang=en-US"
end

dep "Google Chrome.app" do
  source "https://dl-ssl.google.com/chrome/mac/stable/GGRO/googlechrome.dmg"
end

dep "HipChat.app" do
  source "http://downloads.hipchat.com.s3.amazonaws.com/osx/HipChat-2.0.zip"
end

dep "SQLEditor.app" do
  source "http://www.malcolmhardie.com/sqleditor/releases/2.0.12/SQLEditor-2-0-12.zip"
end

dep "Postgres.app" do
  source "https://github.com/PostgresApp/PostgresApp/releases/download/9.3.1.0-alpha1/Postgres93.zip"
end
