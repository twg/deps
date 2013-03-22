dep "deploy user exists" do
  requires "web directory"
  requires "deploy group exists"

  met? {
    "/etc/passwd".p.grep("deploy")
  }

  meet {
    shell "useradd deploy -g deploy"
    # usermod -G wheel deploy
    shell "mkdir /home/deploy/.ssh"
    shell "touch /home/deploy/.ssh/config"
    shell "touch /home/deploy/.ssh/authorized_keys"
    shell "chmod go-rwx /home/deploy/.ssh/*"
    shell "chown -R deploy:deploy /home/deploy/.ssh"
    shell "# chown -R deploy:deploy /web"
  }
end

dep "deploy group exists" do
  met? {
    "/etc/group".p.grep("deploy")
  }
  meet {
    shell "groupadd deploy"
  }
end
