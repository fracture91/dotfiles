#!/usr/bin/env ruby

# Really dumb script to solve a really dumb problem.
#
# Deluge is set up to move finished torrents from SOURCE to DESTINATION.
# Somehow, it got into a state where there was a copy of the files in
# both directories.  Moving through the GUI (essentially invoking
# `deluge-console move`) would silently fail since the destination
# already existed.
#
# This looks at the given `deluge-console info` output file, looks up the
# IDs given on stdin, trashes the dest directory if it exists, and finally
# invokes `deluge-console move` for the given IDs.
#
# The "move" command is not available on 1.3.6-stable, but you can easily
# patch it in by copying the commands/move.py file from develop.

require "set"

torrent_info = File.read(ARGV.shift).split("\n \n").map { |s|
	{ name: /Name: (.*)$/.match(s)[1], id: /ID: (\S+)$/.match(s)[1] }
}

SOURCE = ARGV.shift
DESTINATION = ARGV.shift

# Ugh... `deluge-console move` does not like paths with spaces.
# It uses DESTINATION.split(" ").last or something like that.
# Symlink if you must.
fail "No spaces allowed in dest" if DESTINATION.include? " "
fail "Need trailing slashes" if [SOURCE, DESTINATION].any? { |path| !path.end_with? "/" }

ids_to_move = Set.new(ARGF.map { |line| line.chomp })

to_move = torrent_info.select{ |info| ids_to_move.include? info[:id] }.map do |info|
	exists_in_source = File.exists?("#{SOURCE}#{info[:name]}")
	dest_path = "#{DESTINATION}#{info[:name]}"
	exists_in_dest = File.exists?(dest_path)

	if !exists_in_dest && !exists_in_source
		puts "#{info.inspect} does not exist in dest or source!"
		next
	end

	unless exists_in_source
		puts "#{info.inspect} already moved"
		next
	end

	if exists_in_dest
		puts "trashing #{dest_path}"
		system(*%W[trash #{dest_path}])
	end

	puts "will move #{info.inspect}"
	info
end.compact

# This finishes a lot faster than invoking move separately for each ID,
# but it seems like it's async anyway so you'll have to wait around for this to finish.
cmd = %W[deluge-console move] + to_move.map { |info| info[:id] } + [DESTINATION]
if to_move.empty?
	puts "nothing to move"
else
	system(*cmd)
end
