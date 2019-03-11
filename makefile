# author: Furkan Cayci, 2018
# description:
#   add ghdl to your PATH for simulation
#   add gtkwave to your PATH for displayin the waveform

CC = ghdl
SIM = gtkwave
ARCHNAME = tb_hdmi_out
STOPTIME = 100ms

VHDLSTD = --std=02

#SRCS = $(wildcard rtl/*.vhd)
#SRCS += $(wildcard impl/*.vhd)

SRCS += rtl/clock_gen.vhd
SRCS += rtl/serializer.vhd
SRCS += rtl/tmds_encoder.vhd
SRCS += rtl/timing_generator.vhd
SRCS += rtl/rgb2tmds.vhd
SRCS += rtl/pattern_generator.vhd
SRCS += rtl/objectbuffer.vhd
SRCS += rtl/hdmi_out.vhd

TBS = $(wildcard sim/tb_*.vhd)
TB = sim/$(ARCHNAME).vhd
WORKDIR = debug

XILINX_VIVADO = /opt/apps/Xilinx/Vivado/2018.3
UNISIM_PATH = $(XILINX_VIVADO)/data/vhdl/src/unisims

# all the used primitives are added individually
#UNISRCS += $(UNISIM_PATH)/*.vhd
#UNISRCS += $(UNISIM_PATH)/primitive/*.vhd
UNISRCS += $(UNISIM_PATH)/unisim_VCOMP.vhd
UNISRCS += $(UNISIM_PATH)/unisim_VPKG.vhd
UNISRCS += $(UNISIM_PATH)/primitive/BUFG.vhd
UNISRCS += $(UNISIM_PATH)/primitive/OBUFDS.vhd
UNISRCS += $(UNISIM_PATH)/primitive/PLLE2_ADV.vhd
UNISRCS += $(UNISIM_PATH)/primitive/PLLE2_BASE.vhd
# OSERDESE2 is encrypted IP core, and it cannot
# be simulated using GHDL. Thus, we will downgrade
# it to OSERDESE1 (from 6-series)
UNISRCS += $(UNISIM_PATH)/primitive/OSERDESE1.vhd

OBJS = $(patsubst sim/%.vhd, %.bin, $(TBS))

.PHONY: all
all: clean analyze
	@echo "completed..."

.PHONY: analyze
analyze:
	@echo "analyzing designs..."
	@mkdir -p $(WORKDIR)
	$(CC) -a --work=unisim --workdir=$(WORKDIR) -fexplicit  $(VHDLSTD) \
	  --ieee=synopsys $(UNISRCS)
	$(CC) -a --workdir=$(WORKDIR) -P$(WORKDIR)  $(VHDLSTD) $(SRCS) $(TBS)

.PHONY: simulate
simulate: clean analyze
	@echo "simulating design:" $(TB)
	$(CC) --elab-run --workdir=$(WORKDIR) -P$(WORKDIR) $(VHDLSTD) -fexplicit \
	  --ieee=synopsys -o $(WORKDIR)/$(ARCHNAME).bin $(ARCHNAME) \
	  --vcd=$(WORKDIR)/$(ARCHNAME).vcd --stop-time=$(STOPTIME)
	$(SIM) $(WORKDIR)/$(ARCHNAME).vcd

.PHONY: clean
clean:
	@echo "cleaning design..."
	ghdl --remove --workdir=$(WORKDIR)
	rm -f $(WORKDIR)/*
	rm -rf $(WORKDIR)
