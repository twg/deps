dep "apps", :for => :osx do
  requires [
    "Google Chrome.app",
    "Skitch.app",
    "1Password.app",
    "Dropbox.app",
    "Firefox.app",
    "Postgres.app"
  ]
end

dep "Google Chrome.app" do
  source "https://dl-ssl.google.com/chrome/mac/stable/GGRO/googlechrome.dmg"
end

dep "Skitch.app" do
  source "http://get.skitch.com/skitch.zip"
end

dep "Skype.app" do
  source "http://www.skype.com/en/download-skype/skype-for-mac/downloading/"
end

dep "1Password.app" do
  source "https://d13itkw33a7sus.cloudfront.net/dist/1P/mac/1Password-3.8.20.zip"
end

dep "Postgres.app" do
  source "http://postgresapp.com/download"
end

dep "Dropbox.app" do
  source 'http://cdn.dropbox.com/Dropbox%201.2.49.dmg'
end

dep "Firefox.app" do
  source "https://download.mozilla.org/?product=firefox-19.0.2&os=osx&lang=en-US"
end
