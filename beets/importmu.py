#!/usr/bin/python2
# this should probably be a beets subcommand plugin, but I'm being lazy
# see also: https://github.com/sampsyo/beets/issues/156

import argparse, os, subprocess

desc = """
Import a single directory or archive file with beets.
Optionally delete the source when finished.
"""
ap = argparse.ArgumentParser(description=desc)
ap.add_argument("source", help="Directory or archive to import")
args = ap.parse_args()

def normalize_path(path):
	return os.path.realpath(os.path.abspath(path))

HIGH_QUALITY = normalize_path("/media/Tassadar/Messy Music/High Quality")
norm_source = normalize_path(args.source)
archive_source = None

if not os.path.isdir(norm_source):
	archive_source = norm_source
	print "Extracting {0}".format(norm_source)
	"""
	dtrx handles many archive formats.  The directory it extracts to is
	always just the archive name minus extension.  --one=rename makes it
	rename contained single directories to that same name instead.
	"""
	subprocess.check_call(["dtrx", "--one=rename", norm_source])
	norm_source = os.path.splitext(norm_source)[0]
	if not os.path.isdir(norm_source):
		raise Exception("Extracted directory not found in expected location ({0})".format(norm_source))

subprocess.check_call(["tree", norm_source])
subprocess.call(["beet", "import", norm_source])

def user_approves(message, default=True):
	default_arg = "y" if default else "n"
	y_or_n = "y/n".replace(default_arg, default_arg.upper())
	response = raw_input("{0} {1}: ".format(message, y_or_n)).lower().strip()
	return response == "y" or (response == "" and default)

# use trash instead of deleting files normally so they go to the "recycle bin"
if archive_source is not None:
	if user_approves("Trash archive {0}?".format(archive_source)):
		subprocess.call(["trash", archive_source])
	else: print "Not trashing archive"

trash_by_default = not norm_source.startswith(HIGH_QUALITY)

if user_approves("Trash source {0}?".format(norm_source), trash_by_default):
	subprocess.call(["trash", norm_source])
else: print "Not trashing source"

