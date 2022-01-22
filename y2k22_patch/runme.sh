#! /bin/bash
cd $(dirname "$0")
patch_prg="patch.py"
[[ ! -f $patch_prg ]] && echo "$patch_prg not found" && exit 1
vivado_dirs=""
for mdir in tools opt; do
    mdir="/$mdir/Xilinx/Vivado"
    [[ ! -d $mdir ]] && continue
    vivado_dirs+="$(find $mdir -mindepth 1 -maxdepth 1 -type d) "
done

for vivado_dir in $vivado_dirs; do
    ver=${vivado_dir##*/}
    python_dir="$(find $vivado_dir/tps/lnx64/ -maxdepth 1 -name "python*")"
    echo $python_dir
    python_bins="$(find $python_dir/bin -maxdepth 1 -regex '.*/python[0-9\.]*')"
	python_bins=(${python_bins[@]})
	python_bin="${python_bins[0]}"
    echo "[$python_bin]"
    cmds=("export LD_LIBRARY_PATH=${python_dir}/lib/")
    cmds+=("${python_bin} patch.py")
    for cmd in "${cmds[@]}"; do
        echo "$cmd"
        eval $cmd
    done
done
