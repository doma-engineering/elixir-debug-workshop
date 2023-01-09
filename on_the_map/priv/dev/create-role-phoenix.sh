#!/usr/bin/env bash

set -euo pipefail

# Check that the project compiles.
# This incidentally checks that we're in the project root directory.
echo "Compiling the project for phx.gen.secret to just print the secret without compilation details."
mix deps.get
mix compile

echo "Setting up variables and generating passwords and secrets with phx.gen.secret..."
_pgsql_dev_port=5666
_pw_phoenix=$(mix phx.gen.secret)
_pw_root=$(mix phx.gen.secret)
_sk_seed=$(mix phx.gen.secret)
_user=$(whoami)

echo "Creating bootstrap SQL with role 'phoenix' and role ${_user}..."
cat >/tmp/run.sql <<EOF
create role phoenix with password '${_pw_phoenix}';
alter role phoenix with login;
alter role phoenix createdb;
alter role ${_user} with password '${_pw_root}';
alter role ${_user} with login;
EOF

echo "Running bootstrap SQL script..."
psql -h localhost -p "$_pgsql_dev_port" -d postgres -f /tmp/run.sql
rm /tmp/run.sql

cat <<EOF

* * *

Created role 'phoenix' with password ${_pw_phoenix}
Save this password to your configuration!
For demonstration purposes, restricted local logins to password-based logins.
New password for user ${_user} is ${_pw_root}.

* * *
Saving this password to ~/.pgpass ...
EOF
echo "127.0.0.1:${_pgsql_dev_port}:*:${_user}:${_pw_root}" >> "${HOME}/.pgpass"
echo -n "127.0.0.1:${_pgsql_dev_port}:*:phoenix:${_pw_phoenix}" >> "${HOME}/.pgpass"
chmod 0600 "${HOME}/.pgpass"
echo "Done!"

# TODO: Read application name from mix.exs or the root project directory name.
# Now it's hardcoded to "on_the_map".

# ...

cat <<EOF

* * *
Now saving phoenix password into ./config/dev.secret.exs
EOF

# ...

cat >> "config/dev.secret.exs" <<EOF
import Config

config :on_the_map, OnTheMap.Repo, username: "phoenix", password: "${_pw_phoenix}"
config :on_the_map, OnTheMap.Crypto, sk_seed: "${_sk_seed}"

EOF

chmod 0600 "config/dev.secret.exs"

# ...

cat <<EOF

* * *
Now saving phoenix password into ./config/test.secret.exs
EOF

# ...

cat >> "config/test.secret.exs" <<EOF

import Config

config :on_the_map, OnTheMap.Repo, username: "phoenix", password: "${_pw_phoenix}"

EOF

# ...

chmod 0600 config/test.secret.exs

echo "Done!"
