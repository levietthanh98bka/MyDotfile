#!/usr/bin/env bash

# Env
PATH=/opt/homebrew/bin:$PATH
IS_DARWIN=$(test $(uname -s) = 'Darwin' && echo true || echo false)
IS_ROOT=$(test $USER = root && echo true || echo false)

# Source path
SCRIPT_PATH=$(realpath "$(dirname $0)")
ALL_CONFIGS=${SCRIPT_PATH}/configs

# Config home
USER_CONFIGS=$HOME/.config

# custom plugin path
CUSTOM_PATH=~/.local/share/nvim/site/pack/custom/start/

TARGET=
CONFIGS=

copyPlugin() {
	echo "start copy custom plugin"
	mkdir -p $CUSTOM_PATH
	cp -r ./configs/nvim/myFlugin/* $CUSTOM_PATH
	echo "copy custom plugin done!!!!"
}

setup_dotfiles() {
	if [[ -n $TARGET ]]; then
		echo "[INFO] Setup dotfiles for $TARGET."
	else
		echo "[INFO] Setup dotfiles."
	fi
	echo "--------------------------------------"

	if test $(pwd) != $SCRIPT_PATH; then
		echo "[DEBUG] cd $SCRIPT_PATH"
		cd ${SCRIPT_PATH}
		echo "--------------------------------------"
	fi

	echo "[INFO] Backup or unlink old config"
	for config in "${CONFIGS[@]}"; do
		local conf_path=${USER_CONFIGS}/${config}
		local conf_path_bak=${USER_CONFIGS}/${config}.bak

		if [[ -L $conf_path ]]; then
			echo "[DEBUG] unlink $conf_path"
			unlink $conf_path
		elif [[ -d $conf_path ]]; then
			rm -rf $conf_path_bak
			echo "[DEBUG] Rename: $conf_path -> $conf_path_bak"
			mv $conf_path $conf_path_bak
		fi
	done
	echo "--------------------------------------"

	echo "[INFO] Symlink new configs"
	for config in "${CONFIGS[@]}"; do
		echo "[DEBUG] Create symlink: ${USER_CONFIGS}/${config} -> ${ALL_CONFIGS}/${config}"
		ln -s ${ALL_CONFIGS}/${config} ${USER_CONFIGS}/${config}
	done
	echo "--------------------------------------"

	echo
	echo "[INFO] Completed."
}

main() {
	copyPlugin
	
	if [[ ${IS_ROOT} = true ]]; then
		CONFIGS=("fish")
		TARGET='Root'
	elif [[ ${IS_DARWIN} = true ]]; then
		CONFIGS=("fish" "alacritty")
		TARGET='Darwin'
	else
		echo "Target list:"
		echo "1: For KDE, GNOME, etc    (fish + kitty)"
		echo "2: For WSL                (fish only)"
		echo "_: Cancel"
		echo -n "Select: "
		read answer

		case "${answer}" in
		1)
			CONFIGS=("fish" "kitty" "nvim")
			;;
		2)
			CONFIGS=("fish")
			TARGET='WSL'
			;;
		*)
			echo "Canceled."
			return 0
			;;
		esac
	fi

	echo
	setup_dotfiles
	
}

main
