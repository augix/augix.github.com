#!env python
''' In Mediawiki, lines starting with a whitespace will be translated as code. I'm converting the Mediawiki source pages into Vimwiki pages. 

Therefor, I put a line of {{{ and }}} before and after the block of lines starting with whitespace.'''

import re
existing_code_start = re.compile("<\w+>")
existing_code_end = re.compile("</\w+>")
existing_code_start2 = re.compile("{{{")
existing_code_end2 = re.compile("}}}")
aSpace = re.compile(" \S")

def inside_existing_code(inside, line):
    if re.match(existing_code_start, line) or re.match(existing_code_start2, line):
        inside = True
    if re.match(existing_code_end, line) or re.match(existing_code_end2, line):
        inside = False
    # otherwise, do not change inside
    return inside

def is_code_line(line):
    if re.match(aSpace, line):
        is_code = True
    else:
        is_code = False
    return is_code

def convert(lines):
    outs = [] 
    openState = False
    inside = False
    for l in lines:
        is_code = is_code_line(l)
        inside = inside_existing_code(inside, l)
        if not inside:
            if is_code:
                l = l[1:]
                if openState:
                    pass
                else:
                    l = '{{{\n' + l
                    openState = True
            else:
                if openState:
                    l = '}}}\n' + l
                    openState = False
                else:
                    pass
        else: pass
        outs.append(l)
    if openState: outs.append("\n}}}")
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

