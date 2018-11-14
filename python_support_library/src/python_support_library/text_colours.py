#!/usr/bin/env python
################################################################################
# Filename: text_colours.py
# Created : 27 October 2018
# Author  : Derek Ripper
# Purpose : To provide colour formatting for text to screen for  the 
#           HEARTS python programs
#
################################################################################
# Updates:
#
################################################################################
# usage:
#
#     import python_support_library.text_colours as TC
#
#
#     prt =TC.tc()
#
#     prt.debug("My debug message")
#
#     prt.result("The answer is 42")
#   
#     prt.red("print my text in red")
#
#     prt.bred("print my text in bold red"))
#
#################################################################################

class tc(object):

    # misc ANSI screen conrols  
    reset   = '\033[0m'      # reset screen defults for ALL termnal  text

    ph      = '{}'           # place holder used by format method in Python

    end     = ph+reset       # ends all ansi codes usage "ie reset to defaults"

    # text styles
    norm      = 'm'
    bold      = ';1m'
    faint     = ';2m'
    underline = ';4m'
    crossthru = ';8m'

    # Foreground colours
    fg_black   = '\033[30'
    fg_red     = '\033[31'
    fg_green   = '\033[32'
    fg_yellow  = '\033[33'
    fg_blue    = '\033[34'
    fg_magenta = '\033[35'
    fg_cyan    = '\033[36'
    fg_white   = '\033[37'


    # bacground colours
    bg_black   = '\033[40'
    bg_red     = '\033[41'
    bg_green   = '\033[42' 
    bg_yellow  = '\033[43'
    bg_blue    = '\033[44'
    bg_magenta = '\033[45' 
    bg_cyan    = '\033[46'
    bg_white   = '\033[47'



    # individual text styles by colour - NORMAL 
    def red    (self,txt): print tc.fg_red    +tc.norm+tc.end.format(txt)
    def green  (self,txt): print tc.fg_green  +tc.norm+tc.end.format(txt)
    def yellow (self,txt): print tc.fg_yellow +tc.norm+tc.end.format(txt)
    def blue   (self,txt): print tc.fg_blue   +tc.norm+tc.end.format(txt)
    def magenta(self,txt): print tc.fg_magenta+tc.norm+tc.end.format(txt)
    def cyan   (self,txt): print tc.fg_cyan   +tc.norm+tc.end.format(txt)
    def white  (self,txt): print tc.fg_white  +tc.norm+tc.end.format(txt)
 
     # individul text styles by colour - BOLD 
    def bred    (self,txt): print tc.fg_red    +tc.bold +tc.end.format(txt)
    def bgreen  (self,txt): print tc.fg_green  +tc.bold +tc.end.format(txt)
    def byellow (self,txt): print tc.fg_yellow +tc.bold +tc.end.format(txt)
    def bblue   (self,txt): print tc.fg_blue   +tc.bold +tc.end.format(txt)
    def bmagenta(self,txt): print tc.fg_magenta+tc.bold +tc.end.format(txt)
    def bcyan   (self,txt): print tc.fg_cyan   +tc.bold +tc.end.format(txt)
    def bwhite  (self,txt): print tc.fg_white  +tc.bold +tc.end.format(txt)

   
    # Standard text styles
    def debug   (self,txt): print tc.fg_white  +tc.bold      +tc.bg_blue+tc.norm    + tc.end.format(txt)
    def warning (self,txt): print tc.fg_yellow +tc.bold                             + tc.end.format(txt)
    def error   (self,txt): print tc.fg_red    +tc.bold                             + tc.end.format(txt)
    def info    (self,txt): print tc.fg_cyan   +tc.bold                             + tc.end.format(txt)
    def result  (self,txt): print tc.fg_green  +tc.bold                             + tc.end.format(txt)

if __name__ == '__main__':
    
    import text_colours

    prt = text_colours.tc()

    prt.debug  ("DEBUG  : This is a colour for temporary debug messages")    
    prt.warning("WARNING: This is the colour for non-fatal messages")
    prt.error  ("ERROR  : This the colour for fatal error messages")
    prt.result ("RESULTS: This is the colour for significant results")
    prt.info   ("INFO   : Message info during processing")

