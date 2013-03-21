dep "deploy user" do
  requires ""
end

dep 'passwordless ssh logins', :username, :key do
  username.default('deploy')
  def ssh_dir
    "~#{username}" / '.ssh'
  end

  def group
    shell "id -gn #{username}"
  end

  def sudo?
    @sudo ||= username != shell('whoami')
  end

  met? {
    shell? "fgrep '#{key}' '#{ssh_dir / 'authorized_keys'}'", :sudo => sudo?
  }
  meet {
    shell "mkdir -p -m 700 '#{ssh_dir}'", :sudo => sudo?
    shell "cat >> #{ssh_dir / 'authorized_keys'}", :input => key, :sudo => sudo?
    sudo "chown -R #{username}:#{group} '#{ssh_dir}'" unless ssh_dir.owner == username
    sudo "chown -R #{username}:#{group} '#{ssh_dir / 'authorized_keys'}'" unless (ssh_dir / 'authorized_keys').owner == username
    shell "chmod 600 #{(ssh_dir / 'authorized_keys')}", :sudo => sudo?
  }
end

dep 'public key', :username do
  def hostname
    shell "hostname -f"
  end
  met? {
    '~/.ssh/id_dsa.pub'.p.grep(/^ssh-rsa/)
  }
  meet {
    log shell "Generated keypair", "ssh-keygen -t rsa -f ~/.ssh/id_dsa -P '' -C '#{username}@#{hostname}'"
  }
end

dep 'user setup for provisioning', :username, :key do
  requires [
    'user exists'.with(:username => username),
    'passwordless ssh logins'.with(username, key),
    'passwordless sudo'.with(username)
  ]
end

dep 'app user setup', :username, :key, :env do
  env.default('production')
  requires [
    'user exists'.with(:username => username),
    'user setup'.with(username, key),
    'app env vars set'.with(username, env)
  ]
end

dep 'user auth setup', :username, :password, :key do
  requires 'user exists with password'.with(username, password)
  requires 'passwordless ssh logins'.with(username, key)
end

dep 'user exists with password', :username, :password do
  requires 'user exists'.with(:username => username)
  on :linux do
    met? { shell('sudo cat /etc/shadow')[/^#{username}:[^\*!]/] }
    meet {
      sudo %{echo "#{password}\n#{password}" | passwd #{username}}
    }
  end
end

dep 'user exists', :username, :home_dir_base do
  home_dir_base.default('/home')

  on :osx do
    met? { !shell("dscl . -list /Users").split("\n").grep(username).empty? }
    meet {
      homedir = home_dir_base / username
      {
        'Password' => '*',
        'UniqueID' => (501...1024).detect {|i| (Etc.getpwuid i rescue nil).nil? },
        'PrimaryGroupID' => 'admin',
        'RealName' => username,
        'NFSHomeDirectory' => homedir,
        'UserShell' => '/bin/bash'
      }.each_pair {|k,v|
        # /Users/... here is a dscl path, not a filesystem path.
        sudo "dscl . -create #{'/Users' / username} #{k} '#{v}'"
      }
      sudo "mkdir -p '#{homedir}'"
      sudo "chown #{username}:admin '#{homedir}'"
      sudo "chmod 701 '#{homedir}'"
    }
  end

  on :linux do
    met? { '/etc/passwd'.p.grep(/^#{username}:/) }
    meet {
      sudo "mkdir -p #{home_dir_base}" and
      sudo "useradd -m -s /bin/bash -b #{home_dir_base} -G admin #{username}" and
      sudo "chmod 701 #{home_dir_base / username}"
    }
  end
end
