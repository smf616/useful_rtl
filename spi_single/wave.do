onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -label sim:/tb/dut/Group1 -group {Region: sim:/tb/dut} /tb/dut/sys_clk
add wave -noupdate -expand -label sim:/tb/dut/Group1 -group {Region: sim:/tb/dut} /tb/dut/sys_rst_n
add wave -noupdate -expand -label sim:/tb/dut/Group1 -group {Region: sim:/tb/dut} /tb/dut/miso
add wave -noupdate -expand -label sim:/tb/dut/Group1 -group {Region: sim:/tb/dut} /tb/dut/mosi
add wave -noupdate -expand -label sim:/tb/dut/Group1 -group {Region: sim:/tb/dut} /tb/dut/sclk
add wave -noupdate -expand -label sim:/tb/dut/Group1 -group {Region: sim:/tb/dut} /tb/dut/cs_n
add wave -noupdate -expand -label sim:/tb/dut/Group1 -group {Region: sim:/tb/dut} /tb/dut/control
add wave -noupdate -expand -label sim:/tb/dut/Group1 -group {Region: sim:/tb/dut} /tb/dut/tx_data_valid
add wave -noupdate -expand -label sim:/tb/dut/Group1 -group {Region: sim:/tb/dut} /tb/dut/tx_data_ready
add wave -noupdate -expand -label sim:/tb/dut/Group1 -group {Region: sim:/tb/dut} /tb/dut/tx_data
add wave -noupdate -expand -label sim:/tb/dut/Group1 -group {Region: sim:/tb/dut} /tb/dut/rx_data
add wave -noupdate -expand -label sim:/tb/dut/Group1 -group {Region: sim:/tb/dut} /tb/dut/rx_data_valid
add wave -noupdate -expand -label sim:/tb/dut/Group1 -group {Region: sim:/tb/dut} /tb/dut/CPOL
add wave -noupdate -expand -label sim:/tb/dut/Group1 -group {Region: sim:/tb/dut} -color gold -itemcolor gold /tb/dut/CPHA
add wave -noupdate -expand -label sim:/tb/dut/Group1 -group {Region: sim:/tb/dut} /tb/dut/half_clk_div
add wave -noupdate -expand -label sim:/tb/dut/Group1 -group {Region: sim:/tb/dut} -radix unsigned /tb/dut/bit_length
add wave -noupdate -expand -label sim:/tb/dut/Group1 -group {Region: sim:/tb/dut} /tb/dut/full_clk_div
add wave -noupdate -expand -label sim:/tb/dut/Group1 -group {Region: sim:/tb/dut} /tb/dut/max_clk_edges
add wave -noupdate -expand -label sim:/tb/dut/Group1 -group {Region: sim:/tb/dut} /tb/dut/leading_edge
add wave -noupdate -expand -label sim:/tb/dut/Group1 -group {Region: sim:/tb/dut} /tb/dut/trailing_edge
add wave -noupdate -expand -label sim:/tb/dut/Group1 -group {Region: sim:/tb/dut} /tb/dut/spi_clk_edges
add wave -noupdate -expand -label sim:/tb/dut/Group1 -group {Region: sim:/tb/dut} /tb/dut/tx_bit_count
add wave -noupdate -expand -label sim:/tb/dut/Group1 -group {Region: sim:/tb/dut} /tb/dut/rx_bit_count
add wave -noupdate -expand -label sim:/tb/dut/Group1 -group {Region: sim:/tb/dut} /tb/dut/spi_clk_r
add wave -noupdate -expand -label sim:/tb/dut/Group1 -group {Region: sim:/tb/dut} /tb/dut/spi_clk_count
add wave -noupdate -expand -label sim:/tb/dut/Group1 -group {Region: sim:/tb/dut} /tb/dut/tx_data_1r
add wave -noupdate -expand -label sim:/tb/dut/Group1 -group {Region: sim:/tb/dut} /tb/dut/internal_spi_ready
add wave -noupdate -expand -label sim:/tb/dut/Group1 -group {Region: sim:/tb/dut} /tb/dut/tx_ack
add wave -noupdate -expand -label sim:/tb/dut/Group1 -group {Region: sim:/tb/dut} /tb/dut/tx_ack_1r
add wave -noupdate -expand -label sim:/tb/dut/Group1 -group {Region: sim:/tb/dut} /tb/dut/csn_hold_delay
add wave -noupdate -expand -label sim:/tb/dut/Group1 -group {Region: sim:/tb/dut} /tb/dut/burst_len
add wave -noupdate -expand -label sim:/tb/dut/Group1 -group {Region: sim:/tb/dut} /tb/dut/burst_index
add wave -noupdate -expand -label sim:/tb/dut/Group1 -group {Region: sim:/tb/dut} /tb/dut/in_burst
add wave -noupdate -expand -label sim:/tb/dut/Group1 -group {Region: sim:/tb/dut} /tb/dut/csn_hold_cnt
add wave -noupdate -expand -label sim:/tb/uut_slave/Group1 -group {Region: sim:/tb/uut_slave} /tb/uut_slave/sys_clk
add wave -noupdate -expand -label sim:/tb/uut_slave/Group1 -group {Region: sim:/tb/uut_slave} /tb/uut_slave/sys_rst_n
add wave -noupdate -expand -label sim:/tb/uut_slave/Group1 -group {Region: sim:/tb/uut_slave} /tb/uut_slave/mosi
add wave -noupdate -expand -label sim:/tb/uut_slave/Group1 -group {Region: sim:/tb/uut_slave} /tb/uut_slave/miso
add wave -noupdate -expand -label sim:/tb/uut_slave/Group1 -group {Region: sim:/tb/uut_slave} /tb/uut_slave/sclk
add wave -noupdate -expand -label sim:/tb/uut_slave/Group1 -group {Region: sim:/tb/uut_slave} /tb/uut_slave/cs_n
add wave -noupdate -expand -label sim:/tb/uut_slave/Group1 -group {Region: sim:/tb/uut_slave} /tb/uut_slave/control
add wave -noupdate -expand -label sim:/tb/uut_slave/Group1 -group {Region: sim:/tb/uut_slave} /tb/uut_slave/tx_data_valid
add wave -noupdate -expand -label sim:/tb/uut_slave/Group1 -group {Region: sim:/tb/uut_slave} /tb/uut_slave/tx_data_ready
add wave -noupdate -expand -label sim:/tb/uut_slave/Group1 -group {Region: sim:/tb/uut_slave} /tb/uut_slave/tx_error
add wave -noupdate -expand -label sim:/tb/uut_slave/Group1 -group {Region: sim:/tb/uut_slave} /tb/uut_slave/tx_done_pulse
add wave -noupdate -expand -label sim:/tb/uut_slave/Group1 -group {Region: sim:/tb/uut_slave} /tb/uut_slave/tx_data
add wave -noupdate -expand -label sim:/tb/uut_slave/Group1 -group {Region: sim:/tb/uut_slave} /tb/uut_slave/rx_data
add wave -noupdate -expand -label sim:/tb/uut_slave/Group1 -group {Region: sim:/tb/uut_slave} /tb/uut_slave/rx_data_valid
add wave -noupdate -expand -label sim:/tb/uut_slave/Group1 -group {Region: sim:/tb/uut_slave} /tb/uut_slave/CPHA
add wave -noupdate -expand -label sim:/tb/uut_slave/Group1 -group {Region: sim:/tb/uut_slave} /tb/uut_slave/CPOL
add wave -noupdate -expand -label sim:/tb/uut_slave/Group1 -group {Region: sim:/tb/uut_slave} /tb/uut_slave/bit_length
add wave -noupdate -expand -label sim:/tb/uut_slave/Group1 -group {Region: sim:/tb/uut_slave} /tb/uut_slave/full_clk_div
add wave -noupdate -expand -label sim:/tb/uut_slave/Group1 -group {Region: sim:/tb/uut_slave} /tb/uut_slave/SPI_MODE
add wave -noupdate -expand -label sim:/tb/uut_slave/Group1 -group {Region: sim:/tb/uut_slave} /tb/uut_slave/rx_done
add wave -noupdate -expand -label sim:/tb/uut_slave/Group1 -group {Region: sim:/tb/uut_slave} /tb/uut_slave/rx_data_reg
add wave -noupdate -expand -label sim:/tb/uut_slave/Group1 -group {Region: sim:/tb/uut_slave} /tb/uut_slave/rx_shift_data_pos_sclk
add wave -noupdate -expand -label sim:/tb/uut_slave/Group1 -group {Region: sim:/tb/uut_slave} /tb/uut_slave/rx_shift_data_pos_sclk_tmp
add wave -noupdate -expand -label sim:/tb/uut_slave/Group1 -group {Region: sim:/tb/uut_slave} /tb/uut_slave/rx_data_count_pos_sclk
add wave -noupdate -expand -label sim:/tb/uut_slave/Group1 -group {Region: sim:/tb/uut_slave} /tb/uut_slave/rx_done_pos_sclk
add wave -noupdate -expand -label sim:/tb/uut_slave/Group1 -group {Region: sim:/tb/uut_slave} /tb/uut_slave/rx_shift_data_neg_sclk
add wave -noupdate -expand -label sim:/tb/uut_slave/Group1 -group {Region: sim:/tb/uut_slave} /tb/uut_slave/rx_shift_data_neg_sclk_tmp
add wave -noupdate -expand -label sim:/tb/uut_slave/Group1 -group {Region: sim:/tb/uut_slave} /tb/uut_slave/rx_data_count_neg_sclk
add wave -noupdate -expand -label sim:/tb/uut_slave/Group1 -group {Region: sim:/tb/uut_slave} /tb/uut_slave/rx_done_neg_sclk
add wave -noupdate -expand -label sim:/tb/uut_slave/Group1 -group {Region: sim:/tb/uut_slave} /tb/uut_slave/rx_done_reg1
add wave -noupdate -expand -label sim:/tb/uut_slave/Group1 -group {Region: sim:/tb/uut_slave} /tb/uut_slave/rx_done_reg2
add wave -noupdate -expand -label sim:/tb/uut_slave/Group1 -group {Region: sim:/tb/uut_slave} /tb/uut_slave/rx_done_reg3
add wave -noupdate -expand -label sim:/tb/uut_slave/Group1 -group {Region: sim:/tb/uut_slave} /tb/uut_slave/miso_00
add wave -noupdate -expand -label sim:/tb/uut_slave/Group1 -group {Region: sim:/tb/uut_slave} /tb/uut_slave/miso_01
add wave -noupdate -expand -label sim:/tb/uut_slave/Group1 -group {Region: sim:/tb/uut_slave} /tb/uut_slave/miso_10
add wave -noupdate -expand -label sim:/tb/uut_slave/Group1 -group {Region: sim:/tb/uut_slave} /tb/uut_slave/miso_11
add wave -noupdate -expand -label sim:/tb/uut_slave/Group1 -group {Region: sim:/tb/uut_slave} /tb/uut_slave/txdata_reg
add wave -noupdate -expand -label sim:/tb/uut_slave/Group1 -group {Region: sim:/tb/uut_slave} /tb/uut_slave/tx_data_count_neg_sclk
add wave -noupdate -expand -label sim:/tb/uut_slave/Group1 -group {Region: sim:/tb/uut_slave} /tb/uut_slave/tx_data_count_pos_sclk
add wave -noupdate -expand -label sim:/tb/uut_slave/Group1 -group {Region: sim:/tb/uut_slave} /tb/uut_slave/tx_done_neg
add wave -noupdate -expand -label sim:/tb/uut_slave/Group1 -group {Region: sim:/tb/uut_slave} /tb/uut_slave/tx_done_pos
add wave -noupdate -expand -label sim:/tb/uut_slave/Group1 -group {Region: sim:/tb/uut_slave} /tb/uut_slave/tx_done_reg1
add wave -noupdate -expand -label sim:/tb/uut_slave/Group1 -group {Region: sim:/tb/uut_slave} /tb/uut_slave/tx_done_reg2
add wave -noupdate -expand -label sim:/tb/uut_slave/Group1 -group {Region: sim:/tb/uut_slave} /tb/uut_slave/tx_done_reg3
add wave -noupdate -expand -label sim:/tb/uut_slave/Group1 -group {Region: sim:/tb/uut_slave} /tb/uut_slave/fifo_wne
add wave -noupdate -expand -label sim:/tb/uut_slave/Group1 -group {Region: sim:/tb/uut_slave} /tb/uut_slave/fifo_wnf
add wave -noupdate -expand -label sim:/tb/uut_slave/Group1 -group {Region: sim:/tb/uut_slave} /tb/uut_slave/fifo_wcnt
add wave -noupdate -expand -label sim:/tb/uut_slave/Group1 -group {Region: sim:/tb/uut_slave} /tb/uut_slave/fifo_rd
add wave -noupdate -expand -label sim:/tb/uut_slave/Group1 -group {Region: sim:/tb/uut_slave} /tb/uut_slave/fifo_rne
add wave -noupdate -expand -label sim:/tb/uut_slave/Group1 -group {Region: sim:/tb/uut_slave} /tb/uut_slave/fifo_rnf
add wave -noupdate -expand -label sim:/tb/uut_slave/Group1 -group {Region: sim:/tb/uut_slave} /tb/uut_slave/fifo_rcnt
add wave -noupdate -expand -label sim:/tb/uut_slave/Group1 -group {Region: sim:/tb/uut_slave} /tb/uut_slave/fifo_rreq
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {55331963 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 339
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {117615750 ps}
