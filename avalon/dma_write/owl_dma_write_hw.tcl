# TCL File Generated by Component Editor 18.1
# Fri Nov 17 17:34:17 CST 2023
# DO NOT MODIFY


# 
# owl_dma_write "owl_dma_write" v1.0
#  2023.11.17.17:34:17
# 
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module owl_dma_write
# 
set_module_property DESCRIPTION ""
set_module_property NAME owl_dma_write
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME owl_dma_write
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL owl_dma_write
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file multi_dma_w.sv SYSTEM_VERILOG PATH multi_dma_w.sv
add_fileset_file multi_dma_wc.sv SYSTEM_VERILOG PATH multi_dma_wc.sv
add_fileset_file multi_dma_wc_bst.sv SYSTEM_VERILOG PATH multi_dma_wc_bst.sv
add_fileset_file owl_dma_write.sv SYSTEM_VERILOG PATH owl_dma_write.sv TOP_LEVEL_FILE


# 
# parameters
# 
add_parameter WIDTH INTEGER 1280
set_parameter_property WIDTH DEFAULT_VALUE 1280
set_parameter_property WIDTH DISPLAY_NAME WIDTH
set_parameter_property WIDTH TYPE INTEGER
set_parameter_property WIDTH UNITS None
set_parameter_property WIDTH ALLOWED_RANGES -2147483648:2147483647
set_parameter_property WIDTH HDL_PARAMETER true
add_parameter HEIGHT INTEGER 960
set_parameter_property HEIGHT DEFAULT_VALUE 960
set_parameter_property HEIGHT DISPLAY_NAME HEIGHT
set_parameter_property HEIGHT TYPE INTEGER
set_parameter_property HEIGHT UNITS None
set_parameter_property HEIGHT ALLOWED_RANGES -2147483648:2147483647
set_parameter_property HEIGHT HDL_PARAMETER true
add_parameter PW INTEGER 8
set_parameter_property PW DEFAULT_VALUE 8
set_parameter_property PW DISPLAY_NAME PW
set_parameter_property PW TYPE INTEGER
set_parameter_property PW UNITS None
set_parameter_property PW ALLOWED_RANGES -2147483648:2147483647
set_parameter_property PW HDL_PARAMETER true
add_parameter AW INTEGER 32
set_parameter_property AW DEFAULT_VALUE 32
set_parameter_property AW DISPLAY_NAME AW
set_parameter_property AW TYPE INTEGER
set_parameter_property AW UNITS None
set_parameter_property AW ALLOWED_RANGES -2147483648:2147483647
set_parameter_property AW HDL_PARAMETER true
add_parameter DW INTEGER 64
set_parameter_property DW DEFAULT_VALUE 64
set_parameter_property DW DISPLAY_NAME DW
set_parameter_property DW TYPE INTEGER
set_parameter_property DW UNITS None
set_parameter_property DW ALLOWED_RANGES -2147483648:2147483647
set_parameter_property DW HDL_PARAMETER true
add_parameter DMA_BL INTEGER 3
set_parameter_property DMA_BL DEFAULT_VALUE 3
set_parameter_property DMA_BL DISPLAY_NAME DMA_BL
set_parameter_property DMA_BL TYPE INTEGER
set_parameter_property DMA_BL UNITS None
set_parameter_property DMA_BL ALLOWED_RANGES -2147483648:2147483647
set_parameter_property DMA_BL HDL_PARAMETER true
add_parameter BL INTEGER 4
set_parameter_property BL DEFAULT_VALUE 4
set_parameter_property BL DISPLAY_NAME BL
set_parameter_property BL TYPE INTEGER
set_parameter_property BL UNITS None
set_parameter_property BL ALLOWED_RANGES -2147483648:2147483647
set_parameter_property BL HDL_PARAMETER true
add_parameter APB_AW INTEGER 5
set_parameter_property APB_AW DEFAULT_VALUE 5
set_parameter_property APB_AW DISPLAY_NAME APB_AW
set_parameter_property APB_AW TYPE INTEGER
set_parameter_property APB_AW UNITS None
set_parameter_property APB_AW ALLOWED_RANGES -2147483648:2147483647
set_parameter_property APB_AW HDL_PARAMETER true
add_parameter CH INTEGER 1
set_parameter_property CH DEFAULT_VALUE 1
set_parameter_property CH DISPLAY_NAME CH
set_parameter_property CH TYPE INTEGER
set_parameter_property CH UNITS None
set_parameter_property CH ALLOWED_RANGES -2147483648:2147483647
set_parameter_property CH HDL_PARAMETER true
add_parameter ID STD_LOGIC_VECTOR 3302
set_parameter_property ID DEFAULT_VALUE 3302
set_parameter_property ID DISPLAY_NAME ID
set_parameter_property ID TYPE STD_LOGIC_VECTOR
set_parameter_property ID UNITS None
set_parameter_property ID ALLOWED_RANGES 0:17179869183
set_parameter_property ID HDL_PARAMETER true


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
# connection point src_str
# 
add_interface src_str avalon_streaming end
set_interface_property src_str associatedClock clock
set_interface_property src_str associatedReset reset_sink
set_interface_property src_str dataBitsPerSymbol 12
set_interface_property src_str errorDescriptor ""
set_interface_property src_str firstSymbolInHighOrderBits true
set_interface_property src_str maxChannel 0
set_interface_property src_str readyLatency 0
set_interface_property src_str ENABLED true
set_interface_property src_str EXPORT_OF ""
set_interface_property src_str PORT_NAME_MAP ""
set_interface_property src_str CMSIS_SVD_VARIABLES ""
set_interface_property src_str SVD_ADDRESS_GROUP ""

add_interface_port src_str src_d data Input 12
add_interface_port src_str src_eof channel Input 1
add_interface_port src_str src_rdy ready Output 1
add_interface_port src_str src_val valid Input 1


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

add_interface_port reset_sink rst_n reset_n Input 1


# 
# connection point interrupt_sender
# 
add_interface interrupt_sender interrupt end
set_interface_property interrupt_sender associatedAddressablePoint ""
set_interface_property interrupt_sender associatedClock clock
set_interface_property interrupt_sender associatedReset reset_sink
set_interface_property interrupt_sender bridgedReceiverOffset ""
set_interface_property interrupt_sender bridgesToReceiver ""
set_interface_property interrupt_sender ENABLED true
set_interface_property interrupt_sender EXPORT_OF ""
set_interface_property interrupt_sender PORT_NAME_MAP ""
set_interface_property interrupt_sender CMSIS_SVD_VARIABLES ""
set_interface_property interrupt_sender SVD_ADDRESS_GROUP ""

add_interface_port interrupt_sender irq irq Output 1


# 
# connection point avalon_master
# 
add_interface avalon_master avalon start
set_interface_property avalon_master addressUnits SYMBOLS
set_interface_property avalon_master associatedClock clock
set_interface_property avalon_master associatedReset reset_sink
set_interface_property avalon_master bitsPerSymbol 8
set_interface_property avalon_master burstOnBurstBoundariesOnly false
set_interface_property avalon_master burstcountUnits WORDS
set_interface_property avalon_master doStreamReads false
set_interface_property avalon_master doStreamWrites false
set_interface_property avalon_master holdTime 0
set_interface_property avalon_master linewrapBursts false
set_interface_property avalon_master maximumPendingReadTransactions 0
set_interface_property avalon_master maximumPendingWriteTransactions 0
set_interface_property avalon_master readLatency 0
set_interface_property avalon_master readWaitTime 1
set_interface_property avalon_master setupTime 0
set_interface_property avalon_master timingUnits Cycles
set_interface_property avalon_master writeWaitTime 0
set_interface_property avalon_master ENABLED true
set_interface_property avalon_master EXPORT_OF ""
set_interface_property avalon_master PORT_NAME_MAP ""
set_interface_property avalon_master CMSIS_SVD_VARIABLES ""
set_interface_property avalon_master SVD_ADDRESS_GROUP ""

add_interface_port avalon_master bus_wrdy waitrequest_n Input 1
add_interface_port avalon_master bus_wval write Output 1
add_interface_port avalon_master bus_wlen burstcount Output BL
add_interface_port avalon_master bus_waddr address Output AW
add_interface_port avalon_master bus_wdata writedata Output DW


# 
# connection point avalon_slave
# 
add_interface avalon_slave avalon end
set_interface_property avalon_slave addressUnits WORDS
set_interface_property avalon_slave associatedClock clock
set_interface_property avalon_slave associatedReset reset_sink
set_interface_property avalon_slave bitsPerSymbol 8
set_interface_property avalon_slave burstOnBurstBoundariesOnly false
set_interface_property avalon_slave burstcountUnits WORDS
set_interface_property avalon_slave explicitAddressSpan 0
set_interface_property avalon_slave holdTime 0
set_interface_property avalon_slave linewrapBursts false
set_interface_property avalon_slave maximumPendingReadTransactions 0
set_interface_property avalon_slave maximumPendingWriteTransactions 0
set_interface_property avalon_slave readLatency 0
set_interface_property avalon_slave readWaitTime 1
set_interface_property avalon_slave setupTime 0
set_interface_property avalon_slave timingUnits Cycles
set_interface_property avalon_slave writeWaitTime 0
set_interface_property avalon_slave ENABLED true
set_interface_property avalon_slave EXPORT_OF ""
set_interface_property avalon_slave PORT_NAME_MAP ""
set_interface_property avalon_slave CMSIS_SVD_VARIABLES ""
set_interface_property avalon_slave SVD_ADDRESS_GROUP ""

add_interface_port avalon_slave cpb_a address Input APB_AW
add_interface_port avalon_slave cpb_d writedata Input 32
add_interface_port avalon_slave cpb_q readdata Output 32
add_interface_port avalon_slave cpb_r read Input 1
add_interface_port avalon_slave cpb_w write Input 1
set_interface_assignment avalon_slave embeddedsw.configuration.isFlash 0
set_interface_assignment avalon_slave embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment avalon_slave embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment avalon_slave embeddedsw.configuration.isPrintableDevice 0

