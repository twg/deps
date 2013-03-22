dep "packages" do
  requires [
    "perl.bin",
    "vim.bin",
    "emacs.bin",
    "lsof.bin",
    "tree.bin",
    "pv.bin",
    "htop.bin",
    "iotop.bin",
    "ncdu.bin",
    "wget.bin",
    "traceroute.bin",
    "logrotate.bin",
    "nmap.bin",
    "wget.bin",
    "v8.lib",
    "v8 headers.lib",
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
dep "emacs.bin"
dep "lsof.bin"
dep "tree.bin"
dep "pv.bin"
dep "htop.bin"
dep "iotop.bin"
dep "ncdu.bin"
dep "traceroute.bin"
dep "logrotate.bin"
dep "nmap.bin"
dep 'wget.bin'

dep 'imagemagick.managed' do
  installs {
    via :brew, "imagemagick"
    via :yum, "ImageMagick"
  }
  provides %w( animate compare composite conjure convert display identify import mogrify montage stream )
end

dep 'imagemagick headers.lib' do
  installs {
    via :yum, "ImageMagick-devel"
  }
end

dep 'libxml.lib' do
  installs {
    via :brew, "libxml2"
    via :yum, "libxml"
  }
end

dep 'libxml headers.lib' do
  installs {
    via :yum, "libxml-devel"
  }
end

dep 'libxslt.lib' do
  installs "libxslt"
end

dep 'libxslt headers.lib' do
  installs {
    via :yum, "libxslt-devel"
  }
end

dep 'openssl.bin'
dep 'openssl.lib' do
  installs {
    via :yum, "openssl-libs"
  }
end

dep 'openssl headers.lib' do
  installs {
    via :yum, 'openssl-devel'
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

dep "v8.lib" do
  installs "v8"
end

dep "v8 headers.lib" do
  installs "v8-devel"
end

