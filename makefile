# author: Furkan Cayci, 2018
# description:
#   add ghdl to your PATH for simulation
#   add gtkwave to your PATH for displayin the waveform
#   change the ARCHNAME for simulating different parts

CC = ghdl
SIM = gtkwave
ARCHNAME = tb_hdmi_out
STOPTIME = 100ms

SRCS = $(wildcard rtl/*.vhd)
#SRCS += $(wildcard impl/*.vhd)
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
	$(CC) -a --work=unisim --workdir=$(WORKDIR) -fexplicit --ieee=synopsys $(UNISRCS)
	$(CC) -a --workdir=$(WORKDIR) -P$(WORKDIR) $(SRCS) $(TBS)

.PHONY: simulate
simulate: clean analyze
	@echo "simulating design:" $(TB)
	$(CC) --elab-run --workdir=$(WORKDIR) -P$(WORKDIR) -fexplicit --ieee=synopsys -o $(WORKDIR)/$(ARCHNAME).bin $(ARCHNAME) --wave=$(WORKDIR)/$(ARCHNAME).ghw --stop-time=$(STOPTIME)
	$(SIM) $(WORKDIR)/$(ARCHNAME).ghw

.PHONY: clean
clean:
	@echo "cleaning design..."
	ghdl --remove --workdir=$(WORKDIR)
	rm -f $(WORKDIR)/*
	rm -rf $(WORKDIR)
