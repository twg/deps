dep "apps", :for => :osx do
  requires [
    "1Password.app",
    "Sublime.app",
    "Firefox.app",
    "Google Chrome.app",
    "Postgres.app",
    "Skype.app",
    "SQLEditor.app"
  ]
end

dep "Sublime.app" do
  source "http://c758482.r82.cf2.rackcdn.com/Sublime%20Text%202.0.1.dmg"
end

dep "1Password.app" do
  source "https://d13itkw33a7sus.cloudfront.net/dist/1P/mac/1Password-3.8.20.zip"
end

dep "Firefox.app" do
  source "https://download.mozilla.org/?product=firefox-19.0.2&os=osx&lang=en-US"
end

dep "Google Chrome.app" do
  source "https://dl-ssl.google.com/chrome/mac/stable/GGRO/googlechrome.dmg"
end

dep "Skype.app" do
  source "http://www.skype.com/en/download-skype/skype-for-mac/downloading/"
end

dep "SQLEditor.app" do
  source "http://www.malcolmhardie.com/sqleditor/releases/2.0.12/SQLEditor-2-0-12.zip"
end

dep "Postgres.app" do
  source "http://postgres-app.s3.amazonaws.com/PostgresApp-9-2-4-1.zip"
end
