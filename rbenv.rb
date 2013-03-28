dep "rbenv" do
  requires [
    "git.bin",
    "gemrc",
    "rbenv init",
    "rbenv version set"
  ]

  met? {
    in_path? "rbenv"
  }
  meet {
    git "https://github.com/sstephenson/rbenv.git", :to => "~/.rbenv"
  }
  after {
    log_shell "Rehashing rbenv bin directory ", "rbenv rehash"
  }
end

dep "ruby-build" do
  requires "rbenv"
  met? {
    "~/.rbenv/plugins/ruby-build".p.exists?
  }
  meet {
    git "git://github.com/sstephenson/ruby-build.git", :to => "~/.rbenv/plugins/ruby-build"
  }
  after {
    log_shell "Rehashing rbenv bin directory", "rbenv rehash"
  }
end

dep "rbenv path" do
  "~/.bash_profile".p.append("\nexport PATH=\"$HOME/.rbenv/bin:$PATH\"")
  after {
    log_shell "Reloading .bash_profile ", "source ~/.bash_profile"
  }
end

dep "rbenv init" do
  requires "rbenv path"
  "~/.bash_profile".p.append("\neval \"$(rbenv init -)\"")
  after {
    log_shell "Reloading .bash_profile ", "source ~/.bash_profile"
  }
end

dep "2.0.0.rbenv" do
  patchlevel "0"
end

dep '1.9.3.rbenv' do
  patchlevel "392"
end

dep "gemrc" do
  met? {
    "~/.gemrc".p.exists?
  }
  meet {
    log_shell "Writing gemrc", "echo 'gem: --no-ri --no-rdoc' > ~/.gemrc"
  }
end

dep "rbenv version set" do
  met? {
    "~/.ruby-version".p.exists?
  }
  meet {
    log_shell "Writing ruby-version", "echo '1.9.3-p392' > ~/.ruby-version"
  }
end
