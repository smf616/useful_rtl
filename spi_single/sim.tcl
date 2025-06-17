if ![file isdirectory ./work] { vlib ./work }
vmap work ./work
vlog spi_master.sv
vlog spi_slave_single.sv
vlog xlib_xyz_fifoa.v
vlog tb.sv +libext+.v +libext+.sv
 vsim work.tb  -L altera_mf_ver -voptargs=+acc
 do wave.do
 run -all
