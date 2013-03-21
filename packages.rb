dep "packages" do
  requires %w(
    perl.bin
    vim.bin
    lsof.bin
    tree.bin
    pv.bin
    htop.bin
  )
end

dep "perl.bin"
dep "vim.bin"
dep "lsof.bin"
dep "tree.bin"
dep "pv.bin"
dep "htop.bin" do
  installs {
    via :brew, "htop"
    via :yum, "htop"
  }
end
dep "traceroute.bin"
dep "nmap.bin"

dep 'imagemagick.managed' do
  provides %w( animate compare composite conjure convert display identify import mogrify montage stream )
end

dep 'libxml.lib' do
  installs {
    via :yum, %w( libxml )
  }
  provides []
end

dep 'libxml headers.managed' do
  installs {
    via :yum, %w( libxml-devel )
  }
  provides []
end

dep 'libxslt.lib' do
  installs {
    via :yum, %w( libxslt )
  }
end

dep 'libxslt headers.managed' do
  installs {
    via :yum, %w( libxslt-devel )
  }
  provides []
end

dep 'openssl.managed' do
  installs {
    via :yum, %w( openssl )
  }
  provides %w( openssl  )
end

dep 'openssl.lib' do
  installs {
    via :yum, %w( openssl-libs )
  }
end

dep 'openssl headers.managed' do
  installs {
    via :yum, 'openssl-libs'
  }
  provides []
end

dep 'zlib headers.managed' do
  installs {
    via :yum, 'zlib-devel'
  }
  provides []
end

dep "logrotate.managed"

