# Workshop

The purpose of this workshop is twofold:

1.  Teach experienced engineers what is Elixir and how it works.
2.  Teached experienced engineers how to reason about the systems.

# Install Elixir

We support systems that use Nix on Ubuntu LTS and Windows running WSL with Ubuntu LTS and Nix.
If you're on mac os, we provide a best-effort support.
Some instructions during the workshops may not work, but we have checked that the installation phase and project building works.

We'll be installing an operator's installation (uses GUI, so do it locally) and a developer's installation (conventional way to install stuff)

# Developer's installation

## Linux: Nix + direnv

If you have nix with direnv installed, copy `flake.nix` and `.envrc` into your Git repository.
Run `git add .`.
Now you can run `direnv allow`, and you're good to go.

For VSCode integration, use `cab404/direnv` extension to guarantee that all the projects that use `direnv` will work with it.

### If you don't have `nix`

 1. first [install it with the community installer](https://github.com/numtide/nix-unstable-installer).
 2. To get `direnv` and `home-manager`, you can use [my script to install everything you need](https://github.com/cognivore/nix-home).

It's very opinionated and janky, but we use it everywhere in Doma.

You'll have to edit some files with your user name.
Please follow the instructions you'll see on the screen.

In general, I strongly suggest trying out Nix.
It creates frictionless dev sandboxes and you can even use it to deploy deterministically built stuff.

## Mac os or Linux: Asdf

Asdf is an ad-hoc system that does a thing similar to what Nix Flake does.
It's hacky, but it's ok.
Many people use it, so if you don't feel like figuring out principled system like Nix, this can be your choice.

It also uses purely binary distribution approach, so there's more portability.
(Edit: it actually uses ad-hoc scripts to install things and some scripts compile from source, but since it doesn't manage dependencies, it truly defeats the purpose).

To install Elixir with asdf, follow these steps:

### Install packages

```
sudo apt install automake autoconf libncurses5-dev
```

### Add the Elixir plugin for asdf:

```
asdf plugin-add elixir
asdf plugin-add erlang
```

### Install the desired version of Elixir:

```
asdf install erlang 24.3.4.7
asdf install elixir 1.13.4-otp-24
```

### Set the global Elixir version:

```
asdf global erlang 24.3.4.7
asdf global elixir 1.13.4-otp-24
```

### Verify that Elixir is correctly installed:

```
elixir --version
```

You should see Erlang/OTP XX, Elixir 1.13.4 in the output, where XX is the installed version of Erlang.

### Upgrading Elixir with asdf

To upgrade to a newer version of Elixir, simply repeat the steps to install a new version and set it as the global version.

For example, to upgrade to latest Elixir version, run the following commands:

```
asdf install erlang latest
asdf global erlang latest
asdf install elixir latest
asdf global elixir latest
```

### Uninstalling Elixir with asdf

To uninstall Elixir and remove it from asdf, run the following command:

```
asdf uninstall elixir 1.13.4
```

This will remove the specified version of Elixir, but it will not remove the asdf plugin or other Elixir versions that you have installed.

To completely remove the asdf plugin and all installed Elixir versions, you can run the following command:

```
asdf plugin-remove elixir
```

This will remove the Elixir plugin and all installed Elixir versions from asdf.

### If you don't have `asdf`.


[Follow the official installation instructions](https://asdf-vm.com/guide/getting-started.html#_1-install-dependencies).


# Operator's installation

Operator's installation is required to be installed on the machine.

## Nix + Direnv

Use this flake.nix, write `direnv allow`. You're done.

## Asdf

### Install dependencies

Instead of just automake, autoconf and ncurses, you'll also need libwxwidgets-gtk.

```
sudo apt install automake autoconf libncurses5-dev libwxgtk-webview3.0-gtk3-dev
```

### Later on

Now follow asdf installation guidelines.
