dep "rbenv" do
  requires "git.bin"
  requires "gemrc"

  met? {
    in_path? "rbenv"
  }
  meet {
    git "https://github.com/sstephenson/rbenv.git", :to => "~/.rbenv" and
    "~/.bash_profile".p.append("\nexport PATH=\"$HOME/.rbenv/bin:$PATH\"") and
    "~/.bash_profile".p.append("\neval \"$(rbenv init -)\"") and
    shell "source ~/.bash_profile"
  }
  after {
    log_shell 'Rehashing rbenv bin directory', 'rbenv rehash'
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
    log_shell 'Rehashing rbenv bin directory', 'rbenv rehash'
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
    log_shell "Writing gemrc", "echo 'gem: --no-ri --no-rdoc' >> ~/.gemrc"
  }
end
