meta :nginx do
  def nginx_dir;    "/etc/nginx" end
  def nginx_bin;    "/usr/sbin/nginx" end
  def ssl_path;     "/etc/ssl" end
  def cert_path;    ssl_path / "certs" end
  def nginx_conf;   nginx_dir / "nginx.conf" end
  def vhost_conf;   nginx_dir / "conf.d/#{domain}.conf" end

  def upstream_name
    "#{domain}_upstream"
  end
  def nginx_running?
    shell? "netstat -an | grep -E '^tcp.*[.:]80 +.*LISTEN'"
  end
end
