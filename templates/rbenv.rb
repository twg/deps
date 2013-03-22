meta :rbenv do
  accepts_value_for :version, :basename
  accepts_value_for :patchlevel
  template {
    def version_spec
      "#{version}-p#{patchlevel}"
    end
    def prefix
      "~/.rbenv/versions" / version_spec
    end
    def version_group
      version.scan(/^\d\.\d/).first
    end
    requires 'ruby-build', 'yaml headers.managed', 'openssl.lib'
    met? {
      (prefix / 'bin/ruby').executable? and
      shell(prefix / 'bin/ruby -v')[/^ruby #{version}#{patchlevel}\b/]
    }
    meet {
      shell "rbenv install #{version_spec}"
    }
    after {
      log_shell 'Rehashing rbenv bin directory', 'rbenv rehash'
    }
  }
end
