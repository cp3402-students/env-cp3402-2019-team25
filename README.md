# Prerequisites

[VirtualBox](https://www.virtualbox.org)
[Vagrant](https://www.vagrantup.com)
[Git](https://git-scm.com)

# Installation
Run install.sh. This links the post-merge hook inside ./hooks/ to ./.git/hooks.

post-merge automates updating the database, plugin, and theme submodules after an update.

Scripts should be ran in git Bash.

It is recommended that you use [Github Desktop](https://desktop.github.com) to manage local repositories. It lets you add the submodules as local repositories, and adds your github credentials, which is accessed when you change a submodule's branch.

# Usage

## Scripts
Run start.sh to start and/or update the server.

Run ssh.sh to ssh into the server.

Run stop.sh to stop. There is a choice to server.

Run update_database.sh to update the database; this must be while the server is running. If the database is ahead, nothing happens. If the branch isn't on master, it will be updated along that branch.

Run update_themes_plugins.sh to update all theme and plugin submodules. If the submodule is ahead, nothing happens. If the branch isn't on master, it will be updated along that branch.

Run change_submodule_branch.sh to change the branch of the database, or any theme or plugin submodule. This script uses the git credential helper. If running on windows and using Github Desktop credentials will be automated. OSX and Linux users will need to manage adding their credentials themselves, which can be read about [here](https://help.github.com/en/articles/caching-your-github-password-in-git)

On a merge (after a pull) if the database is behind its branch it will be updated.

## Submodules

New features should be worked on in a dedicated branch, so when it is complete it can be merged back into the master, as the staging server automatically updated along the master branch of each submodule.

# How automation is implemented
The post-merge git hook shell script is ran after a pull is merged to the local repository. This shell script checks the branch and the number of commits behind. If it is behind, it updates.

# Server Account Information

## MySQL Information
Hostname - localhost

Username - root

Password - root

Database - scotchbox

## Wordpress Settings
Username - WebAdmin

Password - gG5XCvUSL4keOwamsEz

# Submodules

[Database](https://github.com/Xett/database-cp3402-2019-team25)

[Theme](https://github.com/Xett/theme-cp3402-2019-team25)

# 3rd Party Plugins
[Wp-scss](https://github.com/ConnectThink/WP-SCSS)
Used to automate sass
