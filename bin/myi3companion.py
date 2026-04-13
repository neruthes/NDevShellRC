import i3ipc

i3 = i3ipc.Connection()

def clean_zed_title(i3, e):
    # Only act on Zed windows
    if e.container.window_class == "dev.zed.Zed":
        full_title = e.container.name
        
        # Check if the delimiter exists
        if " — " in full_title:
            # Split and take the first part
            short_title = full_title.split(" — ")[0]
            # Tell i3 to display only the shortened version
            e.container.command(f'title_format "{short_title}"')
        else:
            # Ensure it resets if the delimiter isn't found
            e.container.command('title_format "%title"')

# Subscribe to both 'focus' and 'title' update events
i3.on('window::focus', clean_zed_title)
i3.on('window::title', clean_zed_title)

i3.main()