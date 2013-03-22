dep "rbenv" do
  requires "ruby-build"
  versions = [ "2.0.0-p0", "1.9.3-p392" ]
  met? {
    versions.each do |version|
      "~/.rbenv/versions/#{version}".p.exists?
    end
  }
  meet {
    versions.each do |version|
      log_shell "Install #{version}", "rbenv install #{version}"
    end
  }
end

meta :rbenv do
  accepts_value_for :version, :basename
  accepts_value_for :patchlevel
end

dep "rbenv installed" do
  met? {
    in_path? "rbenv"
  }
  meet {
    git "https://github.com/sstephenson/rbenv.git", :to => "~/.rbenv"
  }
  after {
    log_shell "Rehash rbenv", "rbenv rehash"
  }
end

dep "ruby-build" do
  requires "rbenv installed"
  met? {
    "~/.rbenv/plugins/ruby-build".p.exists?
  }
  meet {
    git "git://github.com/sstephenson/ruby-build.git", :to => "~/.rbenv/plugins/ruby-build"
  }
end

dep "ree" do
  requires "ruby-build"
  # 1. patch ruby-build with template
  # 2. rbenv install ree-1.8.7-2012.02
  # 3. remove patch
end
