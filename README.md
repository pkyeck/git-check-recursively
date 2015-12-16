# git-check-recursively
Script to recursively check directories for git repos and displays their status

<img width="500" alt="example output of `git-check-recursively`" src="https://cloud.githubusercontent.com/assets/870980/11854037/a4ba1d52-a441-11e5-88b0-0f5bc8f84ba2.png">

Because this should be as quick as possible, the script isn't doing a `git fetch` but only works with the locally available info. So this is not 100% safe/correct but gives you a good overview of where uncommited/untracked changes still need your attention.

## Environments

So far only tested on OS X 10.10.x.
