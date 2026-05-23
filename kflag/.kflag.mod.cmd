savedcmd_kflag.mod := printf '%s\n'   kflag.o | awk '!x[$$0]++ { print("./"$$0) }' > kflag.mod
