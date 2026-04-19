import i3ipc

i3 = i3ipc.Connection()


def clean_zed_title(i3, e):
    # e.container.name can be None during window initialization
    full_title = e.container.name

    if full_title is None:
        return

    if e.container.window_class == "dev.zed.Zed":
        if " — " in full_title:
            short_title = full_title.split(" — ")[0]
            e.container.command(f'title_format "{short_title}"')
        else:
            e.container.command('title_format "%title"')


# Subscribe to both 'focus' and 'title' update events
i3.on("window::focus", clean_zed_title)
i3.on("window::title", clean_zed_title)

i3.main()


### NOTE: Use 'myi3companion.sh' as launcher
### https://github.com/neruthes/NDevShellRC/blob/master/bin/myi3companion.sh
