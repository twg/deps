dep "utilities" do
  requires [
    "perl.bin",
    "vim.bin",
    "emacs.bin",
    "lsof.bin",
    "tree.bin",
    "pv.bin",
    "iotop.bin",
    "ncdu.bin",
    "wget.bin",
    "traceroute.bin",
    "logrotate.bin",
    "nmap.bin",
    "wget.bin"
  ]
end

dep "perl.bin"
dep "vim.bin"
dep "emacs.bin"
dep "lsof.bin"
dep "tree.bin"
dep "pv.bin"
dep "iotop.bin"
dep "ncdu.bin"
dep "wget.bin"
dep "traceroute.bin"
dep "logrotate.bin"
dep "nmap.bin"
dep 'wget.bin'

dep "vim config" do
  met? {
    "~/.vim/vimrc".p.exists?
  }
  meet {
    git "git://github.com/wlangstroth/dotvim.git", :to => "~/.vim"
    shell("cd ~/.vim && ./setup")
  }
end
