import os
from pathlib import Path

OUTFILE = "pub.html"
TMP = "tmp.html"
KEYS = [
    'Liao, Y.',
    'Liao, Y-F.'
]

# Compile publications
cmd = f'pandoc template.md --citeproc --to html -o {TMP}'
os.system(cmd)
with open(TMP, encoding="UTF-8") as f:
    fc = f.read()
Path(TMP).unlink()

# Add bold to targeted names
for k in KEYS:
    fc = fc.replace(k, f"<strong>{k}</strong>")


# Write final output
with open(OUTFILE, "w", encoding="UTF-8") as f:
    f.write(fc)
