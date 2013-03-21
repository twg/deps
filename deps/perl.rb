dep "perl", :template => "bin" do
  met? {
    in_path? "perl"
  }
  meet {
    log_shell "perl installed", "yum install perl -y"
  }
end
