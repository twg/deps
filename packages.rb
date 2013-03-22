dep "packages" do
  requires [
    "perl.bin",
    "vim.bin",
    "lsof.bin",
    "tree.bin",
    "pv.bin",
    "htop.bin",
    "wget.bin",
    "traceroute.bin",
    "logrotate.bin",
    "imagemagick.managed",
    "imagemagick headers.lib",
    "libxml.lib",
    "libxml headers.lib",
    "libxslt.lib",
    "libxslt headers.lib"
  ]
end

dep "perl.bin"
dep "vim.bin"
dep "lsof.bin"
dep "tree.bin"
dep "pv.bin"
dep "htop.bin"
dep "ncdu.bin"
dep "traceroute.bin"
dep "nmap.bin"
dep 'wget.bin'
dep "logrotate.bin"

dep 'imagemagick.managed' do
  provides %w( animate compare composite conjure convert display identify import mogrify montage stream )
end

dep 'imagemagick headers.lib' do
  installs {
    via :yum, %w( imagemagick-devel )
  }
end

dep 'libxml.lib' do
  installs {
    via :brew, %w( libxml2 )
    via :yum, %w( libxml )
  }
end

dep 'libxml headers.lib' do
  installs {
    via :brew, [] # already installed with libxml2
    via :yum, %w( libxml-devel )
  }
end

dep 'libxslt.lib' do
  installs %w( libxslt )
end

dep 'libxslt headers.lib' do
  installs {
    via :brew, [] # already installed with libxslt
    via :yum, %w( libxslt-devel )
  }
end

dep 'openssl.bin'
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

dep 'zlib headers.lib' do
  installs {
    via :yum, 'zlib-devel'
  }
end

dep 'yaml headers.lib' do
  installs {
    via :brew, 'libyaml'
    via :yum, 'libyaml-devel'
  }
end

dep 'readline headers.lib' do
  installs {
    via :brew, "readline"
    via :yum, "readline-devel"
  }
end
