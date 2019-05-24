# Getting Started

## Prerequisites

- [VirtualBox](https://www.virtualbox.org)
- [Vagrant](https://www.vagrantup.com)
- [Git](https://git-scm.com)

## Recommended

[Github Desktop](https://desktop.github.com)

It is recommended that you use Github Desktop to manage local repositories. It lets you add the submodules as local repositories, and adds your github credentials, which is accessed when you change a submodule's branch.

## Installation

Scripts should be ran in Bash. Git bash can be used to run all scripts.

Run `install.sh` This links the post-merge hook inside ./hooks/ to ./.git/hooks.

post-merge automates updating the database, plugin, and theme submodules after an update.

# Usage

**DON'T UPDATE THE ENVIRONMENT IF SUBMODULES ARE NOT USING THE MASTER BRANCH**

## Scripts

- Run `start.sh` to start and/or update the server.
- Run `stop.sh` to stop. There is a choice to server.

- Run `ssh.sh` to ssh into the server.
- Run `update_database.sh` to update the database; this must be while the server is running. If the database is ahead, nothing happens. If the branch isn't on master, it will be updated along that branch.
- Run `update_themes_plugins.sh` to update all theme and plugin submodules. If the submodule is ahead, nothing happens. If the branch isn't on master, it will be updated along that branch.
- Run `change_submodule_branch.sh` to change the branch of the database, or any theme or plugin submodule. This script uses the git credential helper. If running on windows and using Github Desktop credentials will be automated. OSX and Linux users will need to manage adding their credentials themselves, which can be read about [here](https://help.github.com/en/articles/caching-your-github-password-in-git)

On a merge (after a pull) if the database is behind its branch it will be updated.

# Submodules

- [Database](https://github.com/cp3402-students/database-cp3402-2019-team25)
- [Theme](https://github.com/cp3402-students/theme-cp3402-2019-team25)

New features should be worked on in a dedicated branch, so when it is complete it can be merged back into the master, as the staging server automatically updated along the master branch of each submodule. DON'T UPDATE THE ENVIRONMENT UNTIL THE BRANCH HAS BEEN MERGED WITH THE MASTER BRANCH.

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

# 3rd Party Plugins
[Wp-scss](https://github.com/ConnectThink/WP-SCSS) is used to automate sass

# Servers

Local Development Server http://192.168.33.10

Staging Server: http://35.201.21.232

Deployment Server: http://35.244.72.62
