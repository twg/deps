dep "rbenv" do
  requires "git.bin"
  met? {
    in_path? "rbenv"
  }
  meet {
    git "https://github.com/sstephenson/rbenv.git", :to => "~/.rbenv" and
    "~/.bash_profile".p.append('export PATH="$HOME/.rbenv/bin:$PATH"') and
    "~/.bash_profile".p.append('eval "$(rbenv init -)"') and
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

dep "ree.rbenv" do
  # 1. patch ruby-build with template
  # 2. rbenv install ree-1.8.7-2012.02
  # 3. remove patch
end
