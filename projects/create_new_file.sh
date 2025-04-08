#!/bin/zsh

create_file_and_header() {

	echo -n "➡️  Name :  "
	read file_name

	echo -n "➡️  Subdir :  "
	read file_subdir

	touch sources/${file_subdir}/${file_name}.c
	touch includes/${file_name}.h
}

# Call the function
create_file_and_header
