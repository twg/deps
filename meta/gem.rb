meta :gem do
  accepts_value_for :gem_name, :basename
  template {
    met? {
      shell? "gem search --local #{gem_name} | grep #{gem_name}"
    }
    meet {
      log_shell "Installing gem: #{gem_name}", "gem install #{gem_name}"
    }
  }
end
