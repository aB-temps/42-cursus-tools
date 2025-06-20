#!/bin/zsh

create_project_and_alias() {
	local projects_dir="$HOME/projects"

	#project name?
	tput clear
	echo -n "\n➡️  Name :  "
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

	#lib?
	if [[ $archi = "y" ]]; then
		echo -n "➡️  Are you building a library ? [y/n] ? "
		read lib
		if [[ $lib != "y" && $lib != "n" ]]; then
			echo "❌ Error: just say [y]es or [n]o. ❌"
			return 1
		fi
	fi

	#mlx?
	if [[ $archi = "y" ]] && [[ $lib = "n" ]]; then
		echo -n "➡️  Do you need the MiniLibX ? [y/n] ? "
		read mlx
		if [[ $mlx != "y" && $mlx != "n" ]]; then
			echo "❌ Error: just say [y]es or [n]o. ❌"
			return 1
		fi
	fi

	echo "\n"

	# Dir vars
	local dir_name="${project_name}"
	local full_path="${projects_dir}/${dir_name}"

	# Archi vars
	local src="${full_path}/sources"
	local inc="${full_path}/includes"
	local main="${src}/main.c"
	local hdr="${inc}/${project_name}.h"
	local mk="Makefile.mk"

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
			if  [[ $lib = "n" ]]; then
				mkdir -p "$src" && mkdir -p $inc && touch $main && touch $hdr && echo "#include \"${project_name}.h\"\n\nint\tmain(void)\n{\n\n\treturn (0);\n}" >>$main
			fi
			if [[ $? -eq 0 ]]; then
				if [[ $lib = 'y' ]]; then
					mk="Makefile_lib.mk"
				fi
				if [[ $mlx = 'y' ]]; then
					cd $full_path && git clone https://github.com/42paris/minilibx-linux.git
					mv minilibx-linux mlx_linux
					cd mlx_linux && rm -rf .git && rm -rf .github
					mk="Makefile_mlx.mk"
				fi
				cp "$HOME/42-cursus-tools/assets/${mk}" $full_path
				sed -i "s/# NAME = <NAME OF YOUR PROGRAM>/NAME = $project_name/g" $full_path/${mk}
				mv ${full_path}/${mk} ${full_path}/Makefile 
				cd ${full_path} && git clone git@github.com:aB-temps/lib_improved.git
				cd lib_improved && rm -rf .git
				echo ".build/\\nlib_improved/\\n$project_name" >$full_path/.gitignore
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
