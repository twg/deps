dep 'passwordless sudo', :username do
  setup {
    unmeetable! "This dep must be run as root." unless shell('whoami') == 'root'
  }
  met? {
    shell 'sudo -k', :as => username # expire an existing cached password
    shell? 'sudo -n true', :as => username
  }
  meet {
    #shell "echo '#{username} ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers"
    "/etc/sudoers".p.append("#{username} ALL=(ALL) NOPASSWD: ALL")
  }
end

dep 'passwordless sudo removed' do
  requires "perl.bin"
  setup {
    unmeetable! "This dep must be run as root." unless shell('whoami') == 'root'
  }
  met? {
    raw_shell('grep NOPASSWD /etc/sudoers').stdout.empty?
  }
  meet meet{
    shell "perl -pi -e '/NOPASSWD/d' /etc/sudoers"
  }
end
