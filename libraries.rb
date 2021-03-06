dep "libraries" do
  requires [
    "v8.lib",
    "v8 headers.lib",
    "imagemagick.managed",
    "imagemagick headers.lib",
    "freeimage.lib",
    "libxml.lib",
    "libxml headers.lib",
    "libxslt.lib",
    "libxslt headers.lib",
    "yaml headers.lib"
  ]
end

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

dep "freeimage.lib" do
  installs {
    via :yum, "freeimage"
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
dep 'openssl headers.lib' do
  installs {
    via :yum, 'openssl-devel'
  }
end

dep 'zlib headers.lib' do
  installs {
    via :yum, 'zlib-devel'
  }
end

dep "yaml headers.lib" do
  installs {
    via :yum, "libyaml-devel"
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
  installs {
    via :yum, "v8-devel"
  }
end

