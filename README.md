## Dotfiles

[![Build Status](https://travis-ci.org/bitkeen/dotfiles.svg?branch=arch)](https://travis-ci.org/bitkeen/dotfiles)

My local machine setup and dotfiles are managed with Ansible.
Symlinks to the directories are created by running GNU Stow in it.

To learn which components are going to be installed and configured, see the playbook (`ansible/playbook.yml`).

To set up the system from a blank slate with these configs, first install the initial dependencies, then clone the repository:
```sh
pacman -S base-devel git
git clone https://github.com/bitkeen/dotfiles ~/.dotfiles
```

After that, run the bootstrapping script:
```sh
~/.dotfiles/ansible/bootstrap
```

You can also run specific roles by passing tags to `bootstrap`:
```sh
~/.dotfiles/ansible/bootstrap python firefox
```

##### Branches
- `master` - a point at which all the other branches start differing, it is rarely updated now as I mostly use Arch Linux
- `arch` - currently it is the main branch, specific to Arch Linux
- `mac` - changes specific to macOS
- `termux` - changes specific to Termux on Android
