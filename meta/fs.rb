meta :fs do
  def subpaths
    %w[. bin etc include lib sbin share share/doc var].concat(
      (1..9).map {|i| "share/man/man#{i}" }
    )
  end
end
