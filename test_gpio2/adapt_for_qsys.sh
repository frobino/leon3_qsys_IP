#!/bin/bash

# script to port a leon3 project to a IP in Qsys

# NOTE: before running this script, the Leon files must have been created 
#       using make xconfig, and following the reference_files/config.vhd specs
#       (minimal system with SDRAM for DE2-115)

#1 copy/create the wrapper (top_level.vhd) in the designs/leon3-terasic-de2-115/ folder
#
#  To be done
cp ../reference_files/top_level.vhd ../grlib-gpl-1.3.7-b4144/designs/leon3-terasic-de2-115/

#2 modify leon3mp.vhd removing unused ports and adding wrapper (see reference files/leon3mp.vhd)
#
#  To be done
cp ../reference_files/leon3mp.vhd ../grlib-gpl-1.3.7-b4144/designs/leon3-terasic-de2-115/

#3 copy config.vhd and other files to <namefile>2.vhd to avoid names collisions in qsys 
#  (qsys cannot import files with same name, also if they are in different folders) 

#mv ../grlib-gpl-1.3.7-b4144/designs/leon3-terasic-de2-115/config.vhd ../grlib-gpl-1.3.7-b4144/designs/leon3-terasic-de2-115/config2.vhd
#mv ../grlib-gpl-1.3.7-b4144/designs/leon3-terasic-de2-115/leon3mp.vhd ../grlib-gpl-1.3.7-b4144/designs/leon3-terasic-de2-115/leon3mp2.vhd
#mv ../grlib-gpl-1.3.7-b4144/designs/leon3-terasic-de2-115/top_level.vhd ../grlib-gpl-1.3.7-b4144/designs/leon3-terasic-de2-115/top_level2.vhd
cp ../grlib-gpl-1.3.7-b4144/designs/leon3-terasic-de2-115/config.vhd ../grlib-gpl-1.3.7-b4144/designs/leon3-terasic-de2-115/config2.vhd
cp ../grlib-gpl-1.3.7-b4144/designs/leon3-terasic-de2-115/leon3mp.vhd ../grlib-gpl-1.3.7-b4144/designs/leon3-terasic-de2-115/leon3mp2.vhd
cp ../grlib-gpl-1.3.7-b4144/designs/leon3-terasic-de2-115/top_level.vhd ../grlib-gpl-1.3.7-b4144/designs/leon3-terasic-de2-115/top_level2.vhd
perl -pi -e 's/config/config2/g' ../grlib-gpl-1.3.7-b4144/designs/leon3-terasic-de2-115/config2.vhd
perl -pi -e 's/use work.config.all;/use work.config2.all;/g' ../grlib-gpl-1.3.7-b4144/designs/leon3-terasic-de2-115/leon3mp2.vhd
perl -pi -e 's/use work.config.all;/use work.config2.all;/g' ../grlib-gpl-1.3.7-b4144/designs/leon3-terasic-de2-115/top_level2.vhd
