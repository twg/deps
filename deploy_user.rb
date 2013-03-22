dep "deploy user" do
  requires "deploy user owns web"
  requires "bundler.gem"
end

dep "deploy user exists" do
  requires "web directory"
  requires "deploy group"

  met? {
    "/etc/passwd".p.grep(/^deploy/)
  }

  meet {
    shell "useradd deploy -g deploy"
    shell "mkdir /home/deploy/.ssh"
    shell "touch /home/deploy/.ssh/config"
    shell "touch /home/deploy/.ssh/authorized_keys"
    shell "chmod go-rwx /home/deploy/.ssh/*"
    shell "chown -R deploy:deploy /home/deploy/.ssh"
  }
end

dep "deploy group" do
  met? {
    "/etc/group".p.grep(/^deploy/)
  }
  meet {
    shell "groupadd deploy"
  }
end

dep "deploy user owns web" do
  requires "deploy user exists"

  met? {
    # FIXME: This is a weak test
    shell? "ls -l / | grep 'deploy deploy'"
  }
  meet {
    shell "chown -R deploy:deploy /web"
  }
end

dep "bundler.gem"
