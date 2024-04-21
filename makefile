CC=shc
FLAGS=-vrf
SCRIPT=bot_installer.sh
BIN=bot_installer
all:
	${CC} ${FLAGS} ${SCRIPT} -o ${BIN}