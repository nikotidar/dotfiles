# qutewal
config.source('qutewal.py')

# general
c.url.default_page             = "https://www.google.co.id/"
c.url.start_pages              = "https://www.google.co.id/"
c.url.searchengines            = { "DEFAULT" : "https://www.google.co.id/search?hl = en&q = {}" }

# fonts
c.fonts.completion.entry       = "8px scientifica"
c.fonts.completion.category    = "8px scientifica"
c.fonts.debug_console          = "8px scientifica"
c.fonts.downloads              = "8px scientifica"
c.fonts.hints                  = "8px scientifica"
c.fonts.keyhint                = "8px scientifica"
c.fonts.messages.info          = "8px scientifica"
c.fonts.messages.error         = "8px scientifica"
c.fonts.monospace              = "Hack"
c.fonts.prompts                = "8px scientifica"
c.fonts.statusbar              = "8px scientifica"
c.fonts.tabs                   = "8px scientifica"

# encoding
c.content.default_encoding     = 'utf-8'

# path
c.downloads.location.directory = '~/downloads'
c.downloads.position           = 'bottom'

# editors
c.editor.command               = ["urxvt", "-e", "vim '{}'"]
c.editor.encoding              = "utf-8"

# misc
c.window.title_format          = "{private}{perc}{title}{title_sep}qutebrowser"

# shortcuts
config.bind('em', 'spawn mpv {url}')
config.bind('eM', 'hint links spawn mpv {hint-url}')
config.bind("ec", "config-edit")
