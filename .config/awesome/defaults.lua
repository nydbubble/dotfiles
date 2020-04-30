local user = {}

user.terminal = os.getenv("TERMINAL") or "kitty"
user.editor = os.getenv("EDITOR") or "nano"
user.editor_cmd = user.terminal .. " -e " .. user.editor

-- Web browser
user.browser = "firefox"

-- File browser
user.file_browser = "thunar"

return user
