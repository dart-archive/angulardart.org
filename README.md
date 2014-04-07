# Angulardart.org

To build the site locally, do the following:

1 If `which bundle` returns something, you have the prequisites. Otherwise:
  1 Download rubygems [PENDING: say from where]
  1 Install bundler [PENDING: say from where]
1 Run `bundle install` from within the directory that contains the `Gemfile`
  1 If you have issues installing posix-spawn
    (messages like `posix-spawn.c:6:19: error: errno.h: No such file or directory)    do the following and then run `bundle install` again:
    `xcode-select --install`
1 Run `cd site`.
1 Run `jekyll serve --watch`. This runs the dev server.
1 View the site at `localhost:4000`.
