# TCL File Generated by Component Editor 18.1
# Sat Jul 16 01:21:24 CST 2022
# DO NOT MODIFY


# 
# full2half "full2half" v1.0
#  2022.07.16.01:21:24
# 
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module full2half
# 
set_module_property DESCRIPTION ""
set_module_property NAME full2half
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME full2half
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL axi_full_to_half_duplex
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file axi_full_to_half_duplex.v VERILOG PATH axi_full_to_half_duplex.v TOP_LEVEL_FILE


# 
# parameters
# 
add_parameter DATA_WIDTH INTEGER 128 ""
set_parameter_property DATA_WIDTH DEFAULT_VALUE 128
set_parameter_property DATA_WIDTH DISPLAY_NAME DATA_WIDTH
set_parameter_property DATA_WIDTH TYPE INTEGER
set_parameter_property DATA_WIDTH UNITS None
set_parameter_property DATA_WIDTH ALLOWED_RANGES -2147483648:2147483647
set_parameter_property DATA_WIDTH DESCRIPTION ""
set_parameter_property DATA_WIDTH HDL_PARAMETER true
add_parameter ADDR_WIDTH INTEGER 32
set_parameter_property ADDR_WIDTH DEFAULT_VALUE 32
set_parameter_property ADDR_WIDTH DISPLAY_NAME ADDR_WIDTH
set_parameter_property ADDR_WIDTH TYPE INTEGER
set_parameter_property ADDR_WIDTH UNITS None
set_parameter_property ADDR_WIDTH HDL_PARAMETER true
add_parameter ID_WIDTH INTEGER 8
set_parameter_property ID_WIDTH DEFAULT_VALUE 8
set_parameter_property ID_WIDTH DISPLAY_NAME ID_WIDTH
set_parameter_property ID_WIDTH TYPE INTEGER
set_parameter_property ID_WIDTH UNITS None
set_parameter_property ID_WIDTH HDL_PARAMETER true


# 
# display items
# 


# 
# connection point clock
# 
add_interface clock clock end
set_interface_property clock clockRate 0
set_interface_property clock ENABLED true
set_interface_property clock EXPORT_OF ""
set_interface_property clock PORT_NAME_MAP ""
set_interface_property clock CMSIS_SVD_VARIABLES ""
set_interface_property clock SVD_ADDRESS_GROUP ""

add_interface_port clock clk clk Input 1


# 
# connection point reset_sink
# 
add_interface reset_sink reset end
set_interface_property reset_sink associatedClock clock
set_interface_property reset_sink synchronousEdges DEASSERT
set_interface_property reset_sink ENABLED true
set_interface_property reset_sink EXPORT_OF ""
set_interface_property reset_sink PORT_NAME_MAP ""
set_interface_property reset_sink CMSIS_SVD_VARIABLES ""
set_interface_property reset_sink SVD_ADDRESS_GROUP ""

add_interface_port reset_sink rst reset Input 1


# 
# connection point altera_axi4_slave
# 
add_interface altera_axi4_slave axi4 end
set_interface_property altera_axi4_slave associatedClock clock
set_interface_property altera_axi4_slave associatedReset reset_sink
set_interface_property altera_axi4_slave readAcceptanceCapability 1
set_interface_property altera_axi4_slave writeAcceptanceCapability 1
set_interface_property altera_axi4_slave combinedAcceptanceCapability 1
set_interface_property altera_axi4_slave readDataReorderingDepth 1
set_interface_property altera_axi4_slave bridgesToMaster ""
set_interface_property altera_axi4_slave ENABLED true
set_interface_property altera_axi4_slave EXPORT_OF ""
set_interface_property altera_axi4_slave PORT_NAME_MAP ""
set_interface_property altera_axi4_slave CMSIS_SVD_VARIABLES ""
set_interface_property altera_axi4_slave SVD_ADDRESS_GROUP ""

add_interface_port altera_axi4_slave s_axi_araddr araddr Input ADDR_WIDTH
add_interface_port altera_axi4_slave s_axi_arburst arburst Input 2
add_interface_port altera_axi4_slave s_axi_arcache arcache Input 4
add_interface_port altera_axi4_slave s_axi_arid arid Input ID_WIDTH
add_interface_port altera_axi4_slave s_axi_arlen arlen Input 8
add_interface_port altera_axi4_slave s_axi_arlock arlock Input 1
add_interface_port altera_axi4_slave s_axi_arprot arprot Input 3
add_interface_port altera_axi4_slave s_axi_arqos arqos Input 4
add_interface_port altera_axi4_slave s_axi_arready arready Output 1
add_interface_port altera_axi4_slave s_axi_arregion arregion Input 4
add_interface_port altera_axi4_slave s_axi_arsize arsize Input 3
add_interface_port altera_axi4_slave s_axi_arvalid arvalid Input 1
add_interface_port altera_axi4_slave s_axi_awaddr awaddr Input ADDR_WIDTH
add_interface_port altera_axi4_slave s_axi_awburst awburst Input 2
add_interface_port altera_axi4_slave s_axi_awcache awcache Input 4
add_interface_port altera_axi4_slave s_axi_awid awid Input ID_WIDTH
add_interface_port altera_axi4_slave s_axi_awlen awlen Input 8
add_interface_port altera_axi4_slave s_axi_awlock awlock Input 1
add_interface_port altera_axi4_slave s_axi_awprot awprot Input 3
add_interface_port altera_axi4_slave s_axi_awqos awqos Input 4
add_interface_port altera_axi4_slave s_axi_awready awready Output 1
add_interface_port altera_axi4_slave s_axi_awregion awregion Input 4
add_interface_port altera_axi4_slave s_axi_awsize awsize Input 3
add_interface_port altera_axi4_slave s_axi_awvalid awvalid Input 1
add_interface_port altera_axi4_slave s_axi_bid bid Output ID_WIDTH
add_interface_port altera_axi4_slave s_axi_bready bready Input 1
add_interface_port altera_axi4_slave s_axi_bresp bresp Output 2
add_interface_port altera_axi4_slave s_axi_bvalid bvalid Output 1
add_interface_port altera_axi4_slave s_axi_rdata rdata Output DATA_WIDTH
add_interface_port altera_axi4_slave s_axi_rid rid Output ID_WIDTH
add_interface_port altera_axi4_slave s_axi_rlast rlast Output 1
add_interface_port altera_axi4_slave s_axi_rready rready Input 1
add_interface_port altera_axi4_slave s_axi_rresp rresp Output 2
add_interface_port altera_axi4_slave s_axi_rvalid rvalid Output 1
add_interface_port altera_axi4_slave s_axi_wdata wdata Input DATA_WIDTH
add_interface_port altera_axi4_slave s_axi_wlast wlast Input 1
add_interface_port altera_axi4_slave s_axi_wready wready Output 1
add_interface_port altera_axi4_slave s_axi_wstrb wstrb Input DATA_WIDTH/8
add_interface_port altera_axi4_slave s_axi_wvalid wvalid Input 1


# 
# connection point conduit_end
# 
add_interface conduit_end conduit end
set_interface_property conduit_end associatedClock clock
set_interface_property conduit_end associatedReset ""
set_interface_property conduit_end ENABLED true
set_interface_property conduit_end EXPORT_OF ""
set_interface_property conduit_end PORT_NAME_MAP ""
set_interface_property conduit_end CMSIS_SVD_VARIABLES ""
set_interface_property conduit_end SVD_ADDRESS_GROUP ""

add_interface_port conduit_end io_ddr_arw_payload_addr io_ddr_arw_payload_addr Output ADDR_WIDTH
add_interface_port conduit_end io_ddr_arw_payload_burst io_ddr_arw_payload_burst Output 2
add_interface_port conduit_end io_ddr_arw_payload_id io_ddr_arw_payload_id Output ID_WIDTH
add_interface_port conduit_end io_ddr_arw_payload_len io_ddr_arw_payload_len Output 8
add_interface_port conduit_end io_ddr_arw_payload_lock io_ddr_arw_payload_lock Output 2
add_interface_port conduit_end io_ddr_arw_payload_size io_ddr_arw_payload_size Output 3
add_interface_port conduit_end io_ddr_arw_payload_write io_ddr_arw_payload_write Output 1
add_interface_port conduit_end io_ddr_arw_ready io_ddr_arw_ready Input 1
add_interface_port conduit_end io_ddr_arw_valid io_ddr_arw_valid Output 1
add_interface_port conduit_end io_ddr_b_payload_id io_ddr_b_payload_id Input ID_WIDTH
add_interface_port conduit_end io_ddr_b_ready io_ddr_b_ready Output 1
add_interface_port conduit_end io_ddr_b_valid io_ddr_b_valid Input 1
add_interface_port conduit_end io_ddr_r_payload_data io_ddr_r_payload_data Input DATA_WIDTH
add_interface_port conduit_end io_ddr_r_payload_id io_ddr_r_payload_id Input ID_WIDTH
add_interface_port conduit_end io_ddr_r_payload_last io_ddr_r_payload_last Input 1
add_interface_port conduit_end io_ddr_r_payload_resp io_ddr_r_payload_resp Input 2
add_interface_port conduit_end io_ddr_r_ready io_ddr_r_ready Output 1
add_interface_port conduit_end io_ddr_r_valid io_ddr_r_valid Input 1
add_interface_port conduit_end io_ddr_w_payload_data io_ddr_w_payload_data Output DATA_WIDTH
add_interface_port conduit_end io_ddr_w_payload_id io_ddr_w_payload_id Output ID_WIDTH
add_interface_port conduit_end io_ddr_w_payload_last io_ddr_w_payload_last Output 1
add_interface_port conduit_end io_ddr_w_payload_strb io_ddr_w_payload_strb Output DATA_WIDTH/8
add_interface_port conduit_end io_ddr_w_ready io_ddr_w_ready Input 1
add_interface_port conduit_end io_ddr_w_valid io_ddr_w_valid Output 1
