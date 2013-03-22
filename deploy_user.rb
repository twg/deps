dep "deploy user" do
  requires "web directory"
  requires "deploy group"
  requires "deploy user owns web"

  met? {
    "/etc/passwd".p.grep(/^deploy/)
  }

  meet {
    shell "useradd deploy -g deploy"
    # usermod -G wheel deploy
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
  met? {
    # FIXME: This is a weak test
    shell? "ls -l / | grep 'deploy deploy'"
  }
  meet {
    shell "chown -R deploy:deploy /web"
  }
end
