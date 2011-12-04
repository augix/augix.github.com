#!env python
''' In Mediawiki, 3 primes is used as emphasize quote. I'm converting them into <b></b>. '''

import re
existing_code_start = re.compile("<python>")
existing_code_end = re.compile("</python>")
existing_code_start2 = re.compile('{{{class="brush: python"')
existing_code_end2 = re.compile("}}}")
emphasize = re.compile("'''.+'''")

def inside_existing_code(inside, line):
    if re.search(existing_code_start, line) or re.search(existing_code_start2, line):
        inside = True
    if re.search(existing_code_end, line) or re.search(existing_code_end2, line):
        inside = False
    # otherwise, do not change inside
    return inside

def is_pattern_line(pattern, line):
    if re.search(pattern, line):
        is_pattern = True
    else:
        is_pattern = False
    return is_pattern

def replace_emphasize(text):
    """ Convert '''emphasized text''' to <b>emphasized text</b>
    """
    stored = []
    def replace(match_obj):
        match = match_obj.group(0)
        if match in stored:
            stored.pop(stored.index(match))
            return "</b>"
        else:
            stored.append(match)
            return "<b>"
    return re.sub("'''", replace, text)

def convert(lines):
    outs = [] 
    openState = False
    inside = False
    for l in lines:
        is_pattern = is_pattern_line(emphasize, l)
        inside = inside_existing_code(inside, l)
        if is_pattern and not inside:
            l = replace_emphasize(l)
        outs.append(l)
    return outs

# main
import sys
infile = sys.argv[1]
outfile = sys.argv[2]
inf = open(infile, 'r')
outf = open(outfile, 'w')
ins = inf.readlines()
outs = convert(ins)
outf.writelines(outs)
inf.close()
outf.close()

