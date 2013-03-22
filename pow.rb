dep "pow" do
  requires "ruby-build"
  met? {
    "~/Library/Application Support/Pow/Current/bin/pow".p.exists?
  }
  meet {
    log_shell "Installing pow", "curl get.pow.cx | sh"
  }
end

dep "powder.gem" do
  requires "pow"
end
