python << EOF
def zap():
    import vim

    def strip_gremlins(s):
        # Curly double quotes
        s = s.replace(u"\u201c", "\"").replace(u"\u201d", "\"")

        # Curly single quotes
        s = s.replace(u"\u2018", "'").replace(u"\u2019", "'").replace(u"\u02BC", "'")

        # En dashes
        s = s.replace(u"\u2013", "&#8211;")

        # Em dashes
        s = s.replace(u"\u2014", "&#8212;")

        # Copyright sign
        s = s.replace(u"\u00a9", "&#169;")

        # Registered sign
        s = s.replace(u"\u00ae", "&#174;")
        return s

    r = vim.current.range
    for index, line in enumerate(r):
        r[index] = strip_gremlins(line.decode('utf-8')).encode('utf-8')
EOF
