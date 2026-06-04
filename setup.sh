#!/usr/bin/env bash

# Source path
SCRIPT_PATH=$(realpath "$(dirname $0)")
ALL_CONFIGS=${SCRIPT_PATH}/configs

# Config home
USER_CONFIGS=$HOME/.config

CONFIGS=

append_bashrc() {
  LINE='source "$HOME/.config/bash/init.sh"'
  BASHRC="$HOME/.bashrc"

  # Kiểm tra nếu dòng đã tồn tại, nếu chưa thì thêm vào cuối
  if ! grep -Fxq "$LINE" "$BASHRC"; then
      echo "$LINE" >> "$BASHRC"
      echo "✅ Đã thêm vào ~/.bashrc"
  else
      echo "ℹ️ Dòng đã tồn tại trong ~/.bashrc, không cần thêm."
  fi
  source $BASHRC
}

setup_dotfiles() {
	echo "Setup dotfiles."
	echo "--------------------------------------"

	if test $(pwd) != $SCRIPT_PATH; then
		echo "cd $SCRIPT_PATH"
		cd ${SCRIPT_PATH}
		echo "--------------------------------------"
	fi

	echo "Backup or unlink old config"
	for config in "${CONFIGS[@]}"; do
		local conf_path=${USER_CONFIGS}/${config}
		local conf_path_bak=${USER_CONFIGS}/${config}.bak

		if [[ -L $conf_path ]]; then
			echo "unlink $conf_path"
			unlink $conf_path
		elif [[ -d $conf_path ]]; then
			rm -rf $conf_path_bak
			echo "Rename: $conf_path -> $conf_path_bak"
			mv $conf_path $conf_path_bak
		fi
	done
	echo "--------------------------------------"

	echo "Symlink new configs"
	for config in "${CONFIGS[@]}"; do
		echo "Create symlink: ${USER_CONFIGS}/${config} -> ${ALL_CONFIGS}/${config}"
		ln -s ${ALL_CONFIGS}/${config} ${USER_CONFIGS}/${config}
	done
	echo "--------------------------------------"

	echo
	echo "Completed."
}

main() {
	echo "Select config:"
	echo "0: All(fish + kitty + nvim + bash)"
	echo "1: fish + kitty"
	echo "2: fish only (for WSL)"
	echo "3: For nvim"
	echo "4: For bash"
	echo "_: Cancel"
	echo -n "Select: "
	read answer

	case "${answer}" in
	0)
		CONFIGS=("fish" "kitty" "nvim" "bash")
		append_bashrc
		;;
	1)
		CONFIGS=("fish" "kitty")
		;;
	2)
		CONFIGS=("fish")
		;;
	3)
		CONFIGS=("nvim")
		;;
	4)
		CONFIGS=("bash")
		append_bashrc
		;;
	*)
		echo "Canceled."
		return 0
		;;
	esac
	echo
	setup_dotfiles
}

main
