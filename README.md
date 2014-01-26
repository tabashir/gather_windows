Gather Windows is a script that will move all windows to the current display.

I wrote it for when I resume my laptop with a single monitor after suspending when it was plugged into an external. I could use xrandr to reset the screens, but this left windows on the invisible screen if that was where they were prior to suspend.

This just pulls any windows that are partly or fully on that screen to the active one.

I've seen similar using python - I wanted a native bash one.

It can do with a lot of improving - pull requests welcome
