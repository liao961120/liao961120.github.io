curl -LOJ "https://docs.google.com/document/d/1RDHUoyH5QxxF7JvButmt87r1XV5ULhx2soarF4ge86w/export?format=docx"

for f in *.docx; do
    pandoc "$f" -t markdown -s -o "${f%.*}".md --wrap none
    python3 post_process.py "${f%.*}".md
done

