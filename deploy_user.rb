dep "deploy user.task" do
  requires "web directory"

  shell "groupadd deploy"
  shell "useradd deploy -g deploy"
  # usermod -G wheel deploy
  shell "mkdir /home/deploy/.ssh"
  shell "touch /home/deploy/.ssh/config"
  shell "touch /home/deploy/.ssh/authorized_keys"
  shell "chmod go-rwx /home/deploy/.ssh/*"
  shell "chown -R deploy:deploy /home/deploy/.ssh"
  shell "# chown -R deploy:deploy /web"
end
