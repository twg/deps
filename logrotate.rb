dep 'nginx.logrotate', :for => :linux do
  renders "logrotate/nginx.conf"
  as "nginx"
end

dep 'rack.logrotate', :username do
  renders "logrotate/rack.conf"
  as username
end
