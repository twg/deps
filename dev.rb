dep 'dev tools' do
  requires {
    on :osx, 'xcode dev tools'
    on :linux, 'linux dev tools'
  }
end

dep 'linux dev tools', :template => 'bin' do
  installs {
    via :yum, %w[gcc gcc-c++ autoconf automake libtool make]
    via :apt, %w[build-essential autoconf automake libtool]
  }
  provides %w[gcc g++ make ld autoconf automake libtool]
end

dep 'xcode dev tools', :template => 'external' do
  expects %w[cc gcc c++ g++ llvm-gcc llvm-g++ clang make ld libtool]
  otherwise {
    unmeetable! "Install Xcode via the App Store, then go Preferences -> Downloads -> Components -> Command Line Tools."
  }
end
