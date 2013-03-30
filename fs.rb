dep 'writable.fs', :path do
  requires 'layout.fs'.with(path)
  requires_when_unmet 'admins can sudo'
  met? {
    _, nonwritable = subpaths.partition {|subpath| File.writable_real?(path / subpath) }
    nonwritable.empty?.tap {|result|
      log "Some directories within #{path} aren't writable by #{shell 'whoami'}." unless result
    }
  }
  meet {
    confirm "About to enable write access to #{path} for admin users - is that OK?" do
      subpaths.each {|subpath|
        sudo %Q{chgrp admin '#{path / subpath}'}
        sudo %Q{chmod g+w '#{path / subpath}'}
      }
    end
  }
end

dep 'layout.fs', :path do
  met? { subpaths.all? {|subpath| File.directory?(path / subpath) } }
  meet { sudo "mkdir -p #{subpaths.map {|subpath| "'#{path / subpath}'" }.join(' ')}" }
end
