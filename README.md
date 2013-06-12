# deps

Collections of dependencies to put into `~/.matryoshka/deps`.

To try it out on your laptop,

    $ sh -c "`curl http://langstroth.net/projects/matryoshka/setup.sh`"
    $ mk twg:laptop

When you get prompted for where to install matryoshka, the default is
`/usr/matryoshka`. For your laptop, you'll want to change that to
`/usr/local/matryoshka`. For linux distros, the default is preferred.

## Deps and templates

Deps (dependencies) are named after the finished state you want. If you want
legacy user accounts on your server deleted, then you would make a dep like so:

    dep "legacy users deleted" do
      # delete legacy users
    end

Templates are things you wouldn't want to repeat over and over, but you still
want the documentation to be clear. Here's a template for handling our legacy
users:

    meta :legacy_user do
      accepts_value_for :username, :basename
      template {
        met? {
          !"/etc/passwd".p.grep(/^#{username}\:/)
        }
        meet {
          log_shell "Removing user: #{username}", "userdel #{username}"
        }
      }
    end

We can now declare deps like so:

    dep "lp.legacy_user"

and matryoshka will know to get rid of the printer user. It parses the `lp` out of
the dep name as `:basename` above, which we've set as the default value of
`:username` in the `accepts_value_for` declaration.

Check out the examples in this repo, and visit [the babushka
site](http://babushka.me) for more information.
