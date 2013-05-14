dep "nginx.bin"

dep 'configured.nginx', :nginx_prefix do
  requires 'nginx.bin'
  met? {
    Babushka::Renderable.new(nginx_conf).from?(dependency.load_path.parent / "templates/nginx.conf.erb")
  }
  meet {
    render_erb 'templates/nginx.conf.erb', :to => nginx_conf, :sudo => true
  }
end
