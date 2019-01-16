> a script to bulk process Ausplots PDF reports

The goals for this tool are:

  1. rename the reports to remove *noise*. We are only interested in the property name
  1. add PDF metadata for SEO (Search Engine Optimisation)

## Requirements

  1. perl
  1. `exiftool` command
  1. bash terminal

## How to run

  1. ensure all the PDF reports are one directory
  1. open a terminal and `cd` into that directory
  1. run the script: `/path/to/script.sh`

It will create a new directory named `renamed` in the current directory. In that directory you'll find the
renamed and updated (metadata-wise) PDFs. The originals will be left untouched.
