# Use this run.do file to run this example.
# Either bring up ModelSim and type the following at the "ModelSim>" prompt:
#     do run.do
# or, to run from a shell, type the following at the shell prompt:
#     vsim -do run.do -c
# (omit the "-c" to see the GUI while running from the shell)

onbreak {resume}

# create library
if [file exists work] {
    vdel -all
}
vlib work

# compile baseline source files
vlog koggestone4bit.sv ks4tb.sv
# compile top source modules
#vlog mux21x16.sv reg16.sv xor16.v sincos.v angle.v

# start and run simulation
vsim -novopt work.kstb 

view list
view wave

-- display input and output signals as hexidecimal values
# Diplays All Signals recursively
# add wave -hex -r /stimulus/*
add wave -noupdate -divider -height 32 "IN"
add wave -bin /kstb/dut/a
add wave -bin /kstb/dut/b
add wave -bin /kstb/dut/cIn
add wave -noupdate -divider -height 32 "out"
add wave -bin /kstb/dut/s
add wave -bin /kstb/dut/cOut

add list -hex -r /kstb/*
add log -r /*

-- Set Wave Output Items 
TreeUpdate [SetDefaultTree]
WaveRestoreZoom {0 ps} {30 ns}
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2

-- Run the Simulation
run 60
