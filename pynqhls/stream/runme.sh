#! /bin/bash
function get_vivado_dir()
{
	for mdir in opt tools; do
		mdir="/$mdir/Xilinx/Vivado"
		[[ -d $mdir ]] && vivado_dir=$mdir && break
	done
	[[ ! -d $vivado_dir ]] && echo "vivado dir cannot be found!" && exit 
}

function get_latest_vivado_ver() {
	get_vivado_dir
	vers="$(ls -r $vivado_dir)"
	vers=(${vers[@]})
	[[ "${#vers[@]}" -eq "0" ]] && "vivado dir cannot be found" && exit
	latest_ver="${vers[0]}"
}

function patch_tcl()
{
	get_latest_vivado_ver
	cmd="sed -i 's|set scripts_vivado_version .*|set scripts_vivado_version $latest_ver|' $1|head -n 30"
	echo $cmd
	eval $cmd
	head -n 30 $1
}
[[ ! -f /usr/bin/faketime ]] && sudo apt install -y faketime

patch_tcl stream.tcl
cmds=("source $vivado_dir/$latest_ver/settings64.sh")
cmds+=("faketime 2021-01-01 make")
for cmd in "${cmds[@]}"; do
	echo "$cmd"
	$cmd
	[[ "$?" -ne "0" ]] && echo "error!" && exit $?
done
