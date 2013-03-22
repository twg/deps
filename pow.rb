dep "pow" do
  requires [
    "rbenv",
    "powder.gem"
  ]
end

dep "pow installed" do
  met? {
    "~/Library/Application Support/Pow/Current/bin/pow".p.exists?
  }
  meet {
    log_shell "Installing pow", "curl get.pow.cx | sh"
  }
end

dep "powder.gem" do
  requires "pow installed"
end
