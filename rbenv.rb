dep "rbenv with rubies" do
  requires [
    "gemrc",
    "2.0.0.rbenv",
    "1.9.3.rbenv"
  ]
end

dep "gemrc" do
  met? {
    "~/.gemrc".p.exists?
  }
  after {
    log_shell "Rehashing rbenv bin directory ", "rbenv rehash"
  }
  meet {
    log_shell "Writing gemrc", "echo 'gem: --no-ri --no-rdoc' > ~/.gemrc"
  }
end

dep "rbenv" do
  requires "git.bin"

  met? {
    "~/.rbenv/bin/rbenv".p.exists?
  }
  meet {
    git "https://github.com/sstephenson/rbenv.git", :to => "~/.rbenv"
  }
end

dep "rbenv init" do
  requires "rbenv"

  "~/.bash_profile".p.append("\nexport PATH=\"$HOME/.rbenv/bin:$PATH\"")
  "~/.bash_profile".p.append("\neval \"$(rbenv init -)\"")

  after {
    log_shell "Reloading .bash_profile ", "source ~/.bash_profile"
  }
end

dep "ruby-build" do
  requires "rbenv init"

  met? {
    "~/.rbenv/plugins/ruby-build".p.exists?
  }
  meet {
    git "git://github.com/sstephenson/ruby-build.git", :to => "~/.rbenv/plugins/ruby-build"
  }
end

dep "2.0.0.rbenv" do
  patchlevel "195"
end

dep '1.9.3.rbenv' do
  patchlevel "392"
end

# This is the last ruby that works with rails 2.3
dep '1.9.2.rbenv' do
  patchlevel "320"
end

