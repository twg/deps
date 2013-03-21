dep "perl.bin"
dep "vim.bin"
dep "tree.bin"

dep 'imagemagick.managed' do
  provides %w[compare animate convert composite conjure import identify stream display montage mogrify]
end

dep 'libxml.managed' do
  installs {
    via :yum, %w( libxml libxml2-devel )
  }
  provides []
end

dep 'libxslt.managed' do
  installs {
    via :yum, %w( libxslt libxslt-devel )
  }
  provides []
end
