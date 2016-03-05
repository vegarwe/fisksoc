#!/bin/bash

set -e

function clean {
    mkdir -p work osvvm
    ghdl --clean --workdir=work
    ghdl --clean --workdir=osvvm
}

function build_OSVVM {
    mkdir -p osvvm
    ghdl -a --std=08 --work=osvvm --workdir=osvvm --ieee=standard OSVVM/NamePkg.vhd
    ghdl -a --std=08 --work=osvvm --workdir=osvvm --ieee=standard OSVVM/OsvvmGlobalPkg.vhd
    ghdl -a --std=08 --work=osvvm --workdir=osvvm --ieee=standard OSVVM/TranscriptPkg.vhd
    ghdl -a --std=08 --work=osvvm --workdir=osvvm --ieee=standard OSVVM/TextUtilPkg.vhd
    ghdl -a --std=08 --work=osvvm --workdir=osvvm --ieee=standard OSVVM/AlertLogPkg.vhd
    ghdl -a --std=08 --work=osvvm --workdir=osvvm --ieee=standard OSVVM/SortListPkg_int.vhd
    ghdl -a --std=08 --work=osvvm --workdir=osvvm --ieee=standard OSVVM/RandomBasePkg.vhd
    ghdl -a --std=08 --work=osvvm --workdir=osvvm --ieee=standard OSVVM/RandomPkg.vhd
    ghdl -a --std=08 --work=osvvm --workdir=osvvm --ieee=standard OSVVM/MessagePkg.vhd
    ghdl -a --std=08 --work=osvvm --workdir=osvvm --ieee=standard OSVVM/CoveragePkg.vhd
    ghdl -a --std=08 --work=osvvm --workdir=osvvm --ieee=standard OSVVM/MemoryPkg.vhd
    ghdl -a --std=08 --work=osvvm --workdir=osvvm --ieee=standard OSVVM/OsvvmContext.vhd
    ghdl -a --std=08 --work=osvvm --workdir=osvvm --ieee=standard OSVVM/TbUtilPkg.vhd
}

function compile {
    mkdir -p work
    ghdl -a --workdir=work --std=08 --ieee=standard -Posvvm ../fsk_gpio.vhdl
    ghdl -a --workdir=work --std=08 --ieee=standard -Posvvm fsk_gpio_tb.vhdl
    ghdl -e --workdir=work --std=08 --ieee=standard -Posvvm fsk_gpio_tb
}

function run {
    ghdl -r fsk_gpio_tb
}

function wave {
    mkdir -p work
    ghdl -r fsk_gpio_tb --vcd=work/waveform.vcd
    gtkwave work/waveform.vcd > /dev/null 2>&1 &
}

cd `dirname $0`

clean
#build_OSVVM
compile
run
#wave
