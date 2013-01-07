#!/usr/bin/python3

from fplsync import fplsync
import uuid
import subprocess
import os
import argparse

"""
Need to make sure the windows partition is mounted, since that's where fb2k lives.
Quite a hack here.  I want winpart's wrapping behavior, but what can I wrap?  the tail command will
wait for content in a file that doesn't exist, and it will terminate when the process with the
indicated pid terminates, so I can give it the current pid to wait until the script is finished!
"""
DEVNULL = open(os.devnull, "w")
subprocess.Popen(["winpart", "-w", "tail", "-F", "--pid=" + str(os.getpid()), str(uuid.uuid4())],
                 stdin=None, stdout=DEVNULL, stderr=DEVNULL)


config = fplsync.Config()

config.playlist_source = os.path.expanduser("~/.foobar2000/playlists")
config.source = "/media/Tassadar/Music/"
config.fb2k_source_mapping = r"F:\Music"

"""
Using Tassadar subdirectories here in case some app decides to write to the Music or Playlist
directories, since they seem to be somewhat "standard" and likely to be used.
"""
config.dest = "/media/Mengsk/Music/Tassadar"
config.playlist_dest = "/media/Mengsk/Playlists/Tassadar"

# never use up the last gig, and always leave 500 megs free
config.max_size = "-1G"
config.min_free = "500M"

# prefer songs in this order
# Priority Tracks playlist is for stuff that has to be on the card, script will warn otherwise
# (e.g. I want to listen to this album during vacation, make sure it's there)
playlists = ["Priority Tracks", "Ponies", "Rating > 4", "Rating > 3", "Rating > 2"]

# allow overriding some of the default config specified above with fplsync's argument parser
parser = fplsync.make_arg_parser(optional_only=True)
parser.description = ("Sync these foobar2000 playlists and their songs from Tassadar to Mengsk: " +
                     str(playlists) + ". If Priority Tracks doesn't fit entirely, script will" +
                     "warn and prompt to continue.")
parser.parse_args(namespace=config)


director = fplsync.SyncDirector(config)
index = fplsync.PlaylistIndex(config)
for name in playlists:
	try:
		director.add_playlist(index.get_playlist(name))
	except fplsync.OutOfSpaceException as e:
		print(e)
		break
for name in playlists:
	try:
		director.add_songs(index.get_playlist(name), randomly=True)
	except fplsync.OutOfSpaceException as e:
		print(e)
		if name == "Priority Tracks":
			print("!!! Warning: Some Priority Tracks won't fit!")
			if input("Enter Y to continue syncing songs: ") != "Y":
				exit(1)
		break
director.transfer()

