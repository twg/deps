meta :rbenv do
  accepts_value_for :version, :basename
  accepts_value_for :patchlevel
  template {
    def patch
      "p#{patchlevel}"
    end
    def version_spec
      "#{version}-#{patch}"
    end
    def prefix
      "~/.rbenv/versions" / version_spec
    end
    def version_group
      version.scan(/^\d\.\d/).first
    end
    requires [
      'readline headers.lib',
      'ruby-build',
      'yaml headers.lib',
      'openssl headers.lib'
    ]
    met? {
      (prefix / 'bin/ruby').executable? and
      shell(prefix / 'bin/ruby -v')[/^ruby #{version}#{patch}\b/]
    }
    meet {
      shell "rbenv install #{version_spec}"
    }
    after {
      log_shell 'Rehashing rbenv bin directory', 'rbenv rehash'
    }
  }
end
