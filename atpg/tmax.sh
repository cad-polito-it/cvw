#!/bin/bash
#
# tmax.sh - run a TestMAX command file in shell (non-GUI) mode, and check the log
#
# Usage (from this folder, atpg/):   ./tmax.sh <command_file.tcl>
#   e.g.  ./tmax.sh atpg_adder.tcl   (copied from Lab 2)
#
# - TestMAX runs inside run/ (created if needed): every file it writes ends up
#   in atpg/run, and the command file reads the sources as ../<file>.
# - The whole transcript is shown on the screen AND saved in run/<name>.log
#   (fsim_ex1.tcl -> run/fsim_ex1.log).
# - At the end the script tells you whether the log contains errors and prints
#   the first one: by default TestMAX stops executing a command file at the
#   first error (User Guide, "Using Command Files").
# The executable is still called tmax, a legacy of the former name TetraMAX.

cd "$(dirname "${0}")"
script=${1}
if [ -z "${script}" ]; then
	echo "Usage: $0 <command_file.tcl>"
	exit 1
fi
[ ! -f "${script}" ] && echo "Command file \"${script}\" not found in $(pwd)!" && exit 1
script=$(readlink -f "${script}")
log="$(pwd)/run/$(basename "${script}" .tcl).log"

mkdir -p run && cd run
# stdin from /dev/null: after an error TestMAX stops the command file and goes
# back to its prompt; reading end-of-file there makes it exit instead of
# waiting for the keyboard
tmax -shell "${script}" < /dev/null 2>&1 | tee "${log}"

echo
echo "================================================================"
echo "Log saved in run/$(basename "${log}")"
n_err=$(grep -c "^ *Error" "${log}")
if [ "${n_err}" -eq 0 ]; then
	echo "No errors in the log."
else
	echo "${n_err} error(s) in the log. The FIRST one (fix it before anything else):"
	grep -n -m1 -B3 "^ *Error" "${log}"
	echo "TestMAX stops at the first error: the commands after it were NOT executed."
fi
echo "================================================================"
