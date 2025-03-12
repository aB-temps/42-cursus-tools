#!/bin/zsh

create_project_and_alias() {
	local projects_dir="$HOME/projects"

	#milestone?
	echo -n "➡️  Milestone :  "
	read project_milestone
	if [[ ! $project_milestone =~ ^[0-9]+$ ]]; then
		echo "❌ Error: Project milestone must be a positive integer. ❌"
		return 1
	fi

	#project name?
	echo -n "➡️  Name :  "
	read project_name
	if [[ -z $project_name ]]; then
		echo "❌ Error: Project name cannot be empty. ❌"
		return 1
	fi

	#archi?
	echo -n "➡️  Do you need a standard project architecture (inc,src,Makefile,...) ? [y/n] ? "
	read archi
	if [[ $archi != "y" && $archi != "n" ]]; then
		echo "❌ Error: just say [y]es or [n]o. ❌"
		return 1
	fi
	echo "\n"

	# Dir vars
	local dir_name="${project_milestone}-${project_name}"
	local full_path="${projects_dir}/${dir_name}"

	# Archi vars
	local src="${full_path}/src"
	local inc="${full_path}/includes"
	local main="${src}/main.c"
	local hdr="${inc}/${project_name}.h"

	# Create the directory
	mkdir -p "$full_path"

	if [[ $? -eq 0 ]]; then
		echo "✨ Project directory created: \e[2m$full_path ✨\e[0m\n"

		# Add the alias to .zshrc
		echo "alias go-${project_name}=\"code ${full_path} && exit\"" >>~/.zshrc
		echo "✨ \e[32mAlias created: \e[1mgo-${project_name}\e[0m ✨"
		echo "Alias added to ~/.zshrc"

		# Build archi if desired
		if [[ $archi = 'y' ]]; then
			mkdir -p "$src" && mkdir -p $inc && touch $main && touch $hdr && echo "#include \"${project_name}.h\"\n\nint\tmain(void)\n{\n\n\treturn (0);\n}" >>$main
			if [[ $? -eq 0 ]]; then
				cp "$HOME/42-cursus-tools/assets/Makefile" $full_path
				sed -i "s/# NAME = XXXXXX/NAME = $project_name/g" $full_path/Makefile
				cd $full_path && git clone git@github.com:aB-temps/lib-improved.git
			fi
		fi

		echo "\e[2mRun 'zrel' to use the new alias immediately.\e[0m"
	else
		echo "❌ \e[31mFailed to create project directory\e[0m ❌"
		return 1
	fi
}

# Call the function
create_project_and_alias
