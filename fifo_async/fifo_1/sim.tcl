if ![file isdirectory ./work] { vlib ./work }
vmap work ./work
vlog  ./\*.*sv
 vsim work.tb_dc_fifo -voptargs=+acc
 do wave.do
 run -all