import re
import sys
from pathlib import Path


def main():
    fp = sys.argv[1]
    new_file = []
    in_post = True
    in_notes = False
    for line in read_file_gen(fp):
        if line.startswith('# DRAFT'):
            in_post = False
            continue
        if line.startswith('[^'):
            in_notes = True
        if in_notes and line.strip() == '':
            in_notes = False
        if in_post or in_notes:
            new_file.append(line)
        
    write_file(''.join(new_file), fp)


def write_file(s, fp):
    with open(fp, "w", encoding="utf-8") as f:
        f.write(s)


def read_file_gen(fp):
    with open(fp, encoding="utf-8") as f:
        for l in f: yield l


if __name__ == '__main__':
    main()
