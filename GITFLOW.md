# Git workflow #

This project uses the git flow-extension to organise the branches.
See: https://danielkummer.github.io/git-flow-cheatsheet/index.html

The main branches are:
* master
* develop
* release

Working branches for topics:
* feature/
* hotfix

## Additional git commands provided by the extension ##

### Start a new feature ###

```git
git flow feature start MYFEATURE
```
This action creates a new feature branch based on 'develop' and switches to it
```git
git flow feature finish MYFEATURE
```
Finish the development of a feature, merge it to the develop branch and switch to develop.

## Useful git commands ##

```git
git commit --amend
```
When we forget to add files and commit we can add those files using this command and append the files to the previous commit.
