leon3_qsys_IP
=============

Include Leon3 processor as IP in Altera Qsys

TBD
===

* test the script
* leon3mp.vhd, the top level of the Leon component, has been edited 
  manually to include the amba_avalon wrapper (top_level.vhd), and must be 
  modified to remove useless pins. 
  THEORETICALLY, if wrapper is inserted as new component in 
  grlib (grlib.pdf p.73), this is done automatically, but now this is done manually 
  (or through the .sh script)
* check the automation and write documentation
  
my personal notes
=================
		 
FOLDER STRUCTURE:
 |
 - grlib-gpl- (included in git repo) : Leon3 SoC (sopc/qsys equivlent)
 - grmon-eval- (NOT included in git repo) : debugger Leon3
 - sparc-elf- (NOT included in git repo) : cross compiler for Leon3 (sparc_v8)
 - test_gpio2 (included in git repo) : final project folder, containing sw to turn on led (GPIO in Qsys)
 
MINIMAL CONFIGURATIONS LEON:
In general, if we want to have only on-chip memory, we need both AHB ROM and RAM (see config.vhd)
-- AHB ROM
  constant CFG_AHBROMEN : integer := 1;
  constant CFG_AHBROPIP : integer := 0;
  constant CFG_AHBRODDR : integer := 16#000#;
  constant CFG_ROMADDR : integer := 16#100#;
  constant CFG_ROMMASK : integer := 16#E00# + 16#100#;
-- AHB RAM
  constant CFG_AHBRAMEN : integer := 1;
  constant CFG_AHBRSZ : integer := 64;
  constant CFG_AHBRADDR : integer := 16#400#;

DE2-115
 - does not support ROM, only RAM, so it is not possible to use only on-chip
 - see config_DE2-115.vhd in minimal_config folder. Configured as:
    * no MMU
    * yes serial, yes jtag
    * yes 8 bit PROM/SRAM bus support
    * yes SDRAM controller
    * yes Separate address and data buses
    * no ethernet/no can no spi no gpio


BEFORE USING grmon:

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/osso/isomount/Linux_tools/gaisler/grmon-eval-2.0.52/linux/lib

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/osso/Tools/altera/13.0sp1/quartus/linux 
or
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/osso/isomount/Linux_tools/altera/13.1/quartus/linux 


MANUAL:

http://www.rte.se/blog/blogg-modesty-corex/writing-our-first-application-program/1.7
http://people.cs.nctu.edu.tw/~cjtsai/courses/soc/labs/soc11_leon_tutorial.pdf
http://www.nouiz.org/leon2.html

Howto remove pins:

https://groups.yahoo.com/neo/groups/leon_sparc/conversations/topics/21600