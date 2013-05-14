dep "web directory" do
  requires "web directory created"
end

dep "web directory created" do
  requires "web drive starts up"
  met? {
    "/web".p.exists?
  }
  meet {
    "/web".p.create
  }
end

dep "web drive mounted" do
  requires "web directory formatted"
  met? {
    shell("mount -l")[/web/]
  }
  meet {
    log_shell "Mounting /web", "mount /dev/xvdb /web"
  }
end

dep "web drive available" do
  met? {
    shell("fdisk -l")[/dev\/xvdb/]
  }
  meet {
    # This should be an unmeetable condition
    shell("echo 'web drive is not available!'")
  }
end

dep "web drive formatted" do
  requires "web drive available"
  met? {
    shell("mount -l")[/ext4/]
  }
  meet {
    shell("mkfs -t ext4 /dev/xvdb")
  }
end

dep "web drive starts up" do
  requires "web drive formatted"
  met? {
    "/etc/fstab".p.grep(/web1/)
  }
  meet {
    "/etc/fstab".p.append("/dev/xvdb       /web1   auto    defaults,nobootwait     0       0")
  }
end

