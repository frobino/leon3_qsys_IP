--LIBRARY IEEE;
--library grlib;
--USE IEEE.STD_LOGIC_1164.ALL;
--use grlib.amba.all;
--use grlib.stdlib.all;
--use grlib.devices.all;
-------------------------------
--use work.config.all;
------------------------------
--
--entity top_level_wrapper is 
--	generic (
--				hindex : integer := 5;
--				haddr : integer := 16#eee#;
--				hmask : integer := 16#fff#
--			);
-- 
--	port(
--    --clock and reset signals
--		clk         :  in std_logic;
--		reset       :  in std_logic;
--		
--		
--	--AMBA side signals
--		ahbsi       :  in ahb_slv_in_type; --ahb slave record input type
--		ahbso       :  out ahb_slv_out_type;
--		--test_out : out std_logic
--
--					--AVALON AHB 
--			avm_data_rd : in  std_logic_vector (31 downto 0);
--			avm_data_wr : out   std_logic_vector (31 downto 0);
--			avm_address : out   std_logic_vector (31 downto 0);
--			avm_write   : out   std_logic;
--			avm_read    : out   std_logic;
--			avm_byteenable :out std_logic_vector(3 downto 0);
--			--avm_chipselect : out std_logic;
--			avm_waitrequest : in std_logic
--
--
--	);
--
--end top_level_wrapper;
--
--architecture structural_top of top_level_wrapper is 
--
--
--	--memory module (for testing the read and write of wrapper module)
--	-- component memory_module is 
--	-- port (
--	
--	  --  clock and reset signals
--			-- clk         :  in std_logic;
--			-- reset       :  in std_logic;
--			
--		--	AVALON AHB 
--			-- avm_data_rd : out  std_logic_vector (31 downto 0);
--			-- avm_data_wr : in   std_logic_vector (31 downto 0);
--			-- avm_address : in   std_logic_vector (31 downto 0);
--			-- avm_write   : in  std_logic;
--			-- avm_read    : in   std_logic;
--			-- avm_byteenable : in std_logic_vector(3 downto 0);
--	      -- test_out : out std_logic	
--
--		  -- );
--	-- end component memory_module;	
--
--
--	signal hsel,hready : std_logic;
--	
--
--	--test signals only 
--	--signals for connection of the memory module with AHB 
--	-- signal avm_data_rd : std_logic_vector (31 downto 0);
--	-- signal avm_data_wr : std_logic_vector (31 downto 0); 
--	-- signal avm_address : std_logic_vector (31 downto 0);
--	-- signal avm_write   : std_logic;
--	-- signal avm_read    : std_logic;
--	-- signal avm_byteenable : std_logic_vector (3 downto 0);
--	
--		
----		signal avm_write_reg : std_logic;
--	--AHB plug and play configuration
--	constant VENDOR_CONTRIB    : amba_vendor_type := 16#09#;
--	constant HCONFIG: ahb_config_type := (
--											0 => ahb_device_reg ( VENDOR_CONTRIB, 16#0e1#, 0, 0, 0),
--										--	4 => ahb_membar(haddr, '0', '0', hmask), others => X"00000000"
--										 4 => ahb_membar(haddr, '0', '0', hmask), others => zero32--X"00000000"
--										 );
--										 
--	
--begin
--
---- assigning different values to AHB signals
--	ahbso.hresp   <= "00"; --OKEY response from the slave 
--   ahbso.hsplit  <= (others => '0'); 
--	ahbso.hcache  <= '0';--'1';
--   ahbso.hindex  <= hindex; --driving hindex generic back on the ahbso to the AHB controller 
--  	ahbso.hconfig <= HCONFIG; -- Plug&play configuration
--	ahbso.hirq <= (others =>'0'); -- No interrupt line used
--	
--
--
----P0:process (clk)
----    begin
----      if rising_edge(clk) then
--------				
------							hsel <= ahbsi.hsel(hindex)and (ahbsi.htrans(1));
------								hready <= ahbsi.hready;
------								ahbso.hready <= not avm_waitrequest and((not reset) or (hsel and hready) or
------												     (ahbsi.hsel(hindex) and 
------													   not ahbsi.htrans(1) and 
------													   ahbsi.hready));	  
----      ahbso.hrdata  <=avm_data_rd ;--ahbdrivedata(avm_data_rd);
----		
----	  end if;
----    end process P0;
----	 
----				avm_write     <= ahbsi.hwrite;
----	
----
----				avm_read      <= not(ahbsi.hwrite);
----	       	avm_address(31 downto 20)   <= ahbsi.haddr(31 downto 20) and x"000";
----          avm_address(19 downto 0)    <= ahbsi.haddr(19 downto 0);
---- 			ahbso.hready <= (not avm_waitrequest);
----
----	
----	
----	--avalon signals mapping 
----		
----	    avm_data_wr <= ahbsi.hwdata(31 downto 0);
------	 avm_address(31 downto 20)   <= (others =>'0');
------   avm_address(19 downto 0)    <= ahbsi.haddr(19 downto 0);
----  
----  --(changing three MSB bytes in the memory mapped address 0xeee00000 to 0x000_00000 and assigining it to o/p)
----		
------	avm_write     <= ahbsi.hwrite;
------	avm_read      <= not(ahbsi.hwrite);
----	   avm_byteenable <= (others=>'1');
----
----
------port mapping 
------ MEM : memory_module port map  (
----							-- clk, 
----							-- reset, 
----							-- avm_data_rd, 
----							-- avm_data_wr, 
----							-- avm_address, 
----							-- avm_write, 
----							-- avm_read, 
----							-- avm_byteenable,
----							-- test_out
----							-- read_test_out,
----							-- write_test_out
----	
----									
----						    -- );
--end architecture;


-----------------------------------------------------------------------------------------------------------------------
--																	Wrapper design using FSM

-----------------------------------------------------------------------------------------------------------------------
--
--LIBRARY IEEE;
--library grlib;
--USE IEEE.STD_LOGIC_1164.ALL;
--use grlib.amba.all;
--use grlib.stdlib.all;
--use grlib.devices.all;
-------------------------------
--use work.config.all;
------------------------------
--
--entity top_level_wrapper is 
--	generic (
--				hindex : integer := 5;
--				haddr : integer := 16#eee#;
--				hmask : integer := 16#fff#
--			);
-- 
--	port(
--    --clock and reset signals
--		clk         :  in std_logic;
--		reset       :  in std_logic;
--		
--		
--	--AMBA side signals
--		ahbsi       :  in ahb_slv_in_type; --ahb slave record input type
--		ahbso       :  out ahb_slv_out_type;
--		--test_out : out std_logic
--
--					--AVALON AHB 
--			avm_data_rd : in  std_logic_vector (31 downto 0);
--			avm_data_wr : out   std_logic_vector (31 downto 0);
--			avm_address : out   std_logic_vector (31 downto 0);
--			avm_write   : out   std_logic;
--			avm_read    : out   std_logic;
--			avm_byteenable :out std_logic_vector(3 downto 0);
--			--avm_chipselect : out std_logic;
--			avm_waitrequest : in std_logic
--
--
--	);
--
--end top_level_wrapper;
----
--architecture structural_top of top_level_wrapper is 
--
--	--signals 	
--	signal hsel,hready : std_logic;
--	signal addr_buffer,data_buffer : std_logic_vector(31 downto 0);
--	signal hsel_input, hready_input, hwrite_input, hwrite_input_nt:std_logic;
--	
--	--state register 
--	type state_type is (IDLE,AHB_DATA,AVA_WR,WAIT_STATE_WR,DONE_WR,AVA_RD,WAIT_STATE_RD,DONE_RD);
--	signal next_state,pres_state:state_type;
--	
--	--AHB plug and play configuration
--	constant VENDOR_CONTRIB    : amba_vendor_type := 16#09#;
--	constant HCONFIG: ahb_config_type := (
--											0 => ahb_device_reg ( VENDOR_CONTRIB, 16#0e1#, 0, 0, 0),
--										   4 => ahb_membar(haddr, '0', '0', hmask), others => zero32--X"00000000"
--										 );
--										 
--	
--begin
--
---- Assigning different values to AHB signals
--	ahbso.hresp   <= "00"; --OKEY response from the slave 
--   ahbso.hsplit  <= (others => '0'); 
--	ahbso.hcache  <= '0';--'1';
--   ahbso.hindex  <= hindex; --driving hindex generic back on the ahbso to the AHB controller 
--  	ahbso.hconfig <= HCONFIG; -- Plug&play configuration
--	ahbso.hirq <= (others =>'0'); -- No interrupt line used
--	hsel_input <=   ahbsi.hsel(hindex);
--	hready_input <= ahbsi.hready; 
--	hwrite_input <= ahbsi.hwrite;
--	hwrite_input_nt <= not (ahbsi.hwrite);
--	
--	------------------------------------------------------------------------------------------------
--	--														FSM for reading and writing from Avalon
--	------------------------------------------------------------------------------------------------
--	
--process(pres_state,hsel_input,hready_input,hwrite_input,avm_waitrequest)
--			begin
--					next_state <= pres_state;
--			case pres_state is
--						
--						when IDLE =>
--									if  (hsel_input ='1' and hready_input ='1' and hwrite_input= '1') then
--										
--										addr_buffer(31 downto 20) <= (others =>'0');
--										addr_buffer(19 downto 0)  <= ahbsi.haddr(19 downto 0);
--										data_buffer <=  (others =>'0');
--										next_state <= AHB_DATA;
--										ahbso.hready <= '0';
--
--										
--									elsif  (hsel_input='1' and hready_input ='1' and  hwrite_input_nt = '1' ) then
--										
--										addr_buffer(31 downto 20) <= (others =>'0');
--										addr_buffer(19 downto 0)  <= ahbsi.haddr(19 downto 0);
--										data_buffer <=  (others =>'0');
--										next_state <= AVA_RD;
--										ahbso.hready <= '0';
--
--										
--									else 
--										addr_buffer(31 downto 0) <= (others => '0');
--										next_state <= IDLE;
--										ahbso.hready <= '0';
--										avm_write   <=  '0';
--										avm_read    <=  '0'; 
--										avm_byteenable <= (others =>'1');
--										avm_data_wr <=   (others =>'0');
--										avm_address <=   (others =>'0');
--										
--									end if;
--										
--
--						when AHB_DATA =>
--									
--									   
--										data_buffer <=  ahbsi.hwdata(31 downto 0);
--										ahbso.hready <= '0';
--										avm_write   <=  '0';
--										avm_read    <=  '0'; 
--										avm_byteenable <= (others =>'1');
--										avm_data_wr <=   (others =>'0');
--										avm_address <=   (others =>'0');
--										next_state <= AVA_WR ;
--									
--						when AVA_WR => 
--						
--										avm_data_wr <=   data_buffer;
--										avm_address <=   addr_buffer; 
--										avm_write   <=   ahbsi.hwrite;
--										avm_read    <=   not ahbsi.hwrite; 
--										avm_byteenable <= (others =>'1');
--										ahbso.hrdata <=  (others =>'0');--avm_data_rd ; 
--										ahbso.hready <= '0';
--										
--											next_state <= WAIT_STATE_WR ;
--											
--						when WAIT_STATE_WR =>
--										
--										if (avm_waitrequest = '0') then
--											
--											next_state <= DONE_WR ;
--											
--											--clear all the signals involved in the transfer 
--											
--																
--										else 
--										   		
--											  --keep all the signals constant here
--											avm_data_wr <=   data_buffer;
--											avm_address <=   addr_buffer; 
--											avm_write   <=   ahbsi.hwrite;
--											avm_read    <=   not ahbsi.hwrite; 
--											avm_byteenable <= (others =>'1');
--											ahbso.hrdata <=  (others =>'0');--avm_data_rd ; 
--											ahbso.hready <= '0';		
--											
--											next_state <= WAIT_STATE_WR ;
--									
--										 
--										end if;
--						
--						
--						when DONE_WR =>
--										
--										avm_write   <=  '0';
--										avm_read    <=  '0'; 
--										avm_byteenable <= (others =>'1');
--										avm_data_wr <=   (others =>'0');
--										avm_address <=   (others =>'0');
--										ahbso.hrdata <=  (others =>'0');
--										ahbso.hready <= '1';
--										next_state   <= IDLE;
--										
--									
--						when AVA_RD => 
--										
--										ahbso.hready <= '0';
--										avm_data_wr <=   (others =>'0');
--										avm_address <=   addr_buffer; 
--										avm_write   <=   ahbsi.hwrite;
--										avm_read    <=   not ahbsi.hwrite; 
--										avm_byteenable <= (others =>'1');
--										ahbso.hrdata <=  (others=> '0') ; 
--										
--										next_state <= WAIT_STATE_RD ;
--											
--						when WAIT_STATE_RD =>
--										
--										if (avm_waitrequest = '0') then
--											
--											ahbso.hrdata  <=ahbdrivedata(avm_data_rd);
--										   ahbso.hready <= '1';
--											next_state <= DONE_RD ;
--											--clear all the signals involved in the transfer 
--										else 
--										   next_state <= WAIT_STATE_RD ;		
--										 --keep all the signals constant here 
--										 	avm_data_wr <=   (others =>'0');
--											avm_address <=   addr_buffer; 
--											avm_write   <=   ahbsi.hwrite;
--											avm_read    <=   not ahbsi.hwrite; 
--											avm_byteenable <= (others =>'1');
--											ahbso.hrdata <=  (others=> '0') ; 
--											ahbso.hready <= '0';
--											 
--										 
--										end if;
--						
--						
--					   when DONE_RD =>
--										
--										avm_address <=   (others=> '0'); 
--										avm_write   <=   '0';
--										avm_read    <=   '0'; 
--										ahbso.hrdata  <=ahbdrivedata(avm_data_rd) ;
--										ahbso.hready <= '1';
--										next_state   <= IDLE;	   
--									
--
--			end case;
--end process;
--		
--		
-----------------------------------------------------------------------------------------------
----													process for state transition
-----------------------------------------------------------------------------------------------		
--regs: process(clk,reset)
--begin
--		if (reset='1') then -- asynchronous reset
-- 			 pres_state <=IDLE;
--		elsif (clk='1') and clk'event then
-- 			 pres_state <= next_state;
--		end if;
--end process;
----	
--------------------------------------------------------------------------------------------------------------------
--
--end architecture;
-----------------------------------------------------------------------------------------------------------------------------------

-- 															FSM WITH SEPARATE DATAPATH 

--------------------------------------------------------------------------------------------------------------------------------
--
--LIBRARY IEEE;
--library grlib;
--USE IEEE.STD_LOGIC_1164.ALL;
--use grlib.amba.all;
--use grlib.stdlib.all;
--use grlib.devices.all;
-------------------------------
--use work.config.all;
------------------------------
--
--entity top_level_wrapper is 
--	generic (
--				hindex : integer := 5;
--				haddr : integer := 16#eee#;
--				hmask : integer := 16#fff#
--			);
-- 
--	port(
--    --clock and reset signals
--		clk         :  in std_logic;
--		reset       :  in std_logic;
--		
--		
--	--AMBA side signals
--		ahbsi       :  in ahb_slv_in_type; --ahb slave record input type
--		ahbso       :  out ahb_slv_out_type;
--		--test_out : out std_logic
--
--					--AVALON AHB 
--			avm_data_rd : in  std_logic_vector (31 downto 0);
--			avm_data_wr : out   std_logic_vector (31 downto 0);
--			avm_address : out   std_logic_vector (31 downto 0);
--			avm_write   : out   std_logic;
--			avm_read    : out   std_logic;
--			avm_byteenable :out std_logic_vector(3 downto 0);
--			--avm_chipselect : out std_logic;
--			avm_waitrequest : in std_logic
--
--
--	);
--
--end top_level_wrapper;
----
--architecture structural_top of top_level_wrapper is 
--
--	--signals 	
--	signal hsel,hready : std_logic;
--	signal addr_buffer,data_buffer : std_logic_vector(19 downto 0);
--	signal hsel_input, hready_input, hwrite_input, hwrite_input_nt:std_logic;
--	
--	
--		
--	--AHB plug and play configuration
--	constant VENDOR_CONTRIB    : amba_vendor_type := 16#09#;
--	constant HCONFIG: ahb_config_type := (
--											0 => ahb_device_reg ( VENDOR_CONTRIB, 16#0e1#, 0, 0, 0),
--										   4 => ahb_membar(haddr, '0', '0', hmask), others => zero32--X"00000000"
--										 );
--										 
--	constant IDLE:std_logic_vector(0 to 7)				:="10000000";
--	constant AHB_DATA:std_logic_vector(0 to 7)		:="01000000";
--	constant AVA_WR:std_logic_vector(0 to 7)			:="00100000";
--	constant WAIT_STATE_WR:std_logic_vector(0 to 7) :="00010000";
--	constant DONE_WR:std_logic_vector(0 to 7)			:="00001000";
--	constant AVA_RD:std_logic_vector(0 to 7)			:="00000100";
--	constant WAIT_STATE_RD:std_logic_vector(0 to 7)	:="00000010";
--	constant DONE_RD:std_logic_vector(0 to 7)			:="00000001";
--	
--	constant sel_hready:std_logic_vector(0 to 7)		:="00001011";
--	constant sel_hrdata:std_logic_vector(0 to 7)		:="00000011";
--	constant sel_avmrd:std_logic_vector(0 to 7)		:="11001001";
--	constant sel_avmwr:std_logic_vector(0 to 7)		:="11001001";
--	constant sel_avmdatawr:std_logic_vector(0 to 7)	:="00110000";
--	constant sel_avmaddr:std_logic_vector(0 to 7)	:="00110110";
--	
--	
--	-- State vector
--	subtype state_type is integer range 0 to 5;
--	signal counter:state_type;
--	-- Datapath signals
----	signal Reg1,Reg2,Pmul:std_logic_vector(Width-1 downto 0);
----	signal mux1,mux2,mux3,add:std_logic_vector(Width-1 downto 0);
--
--	signal	mux_hready, mux_avmread, mux_avmwrite  : std_logic;
--	signal   mux_avmdatawr, mux_avmaddr, mux_hrdata	: std_logic_vector (31 downto 0);
--							 
--
--										 
--	
--begin
--
---- Assigning different values to AHB signals
--	ahbso.hresp   <= "00"; --OKEY response from the slave 
--   ahbso.hsplit  <= (others => '0'); 
--	ahbso.hcache  <= '0';--'1';
--   ahbso.hindex  <= hindex; --driving hindex generic back on the ahbso to the AHB controller 
--  	ahbso.hconfig <= HCONFIG; -- Plug&play configuration
--	ahbso.hirq <= (others =>'0'); -- No interrupt line used
--	hsel_input <=   ahbsi.hsel(hindex);
--	hready_input <= ahbsi.hready; 
--	hwrite_input <= ahbsi.hwrite;
--	hwrite_input_nt <= not (ahbsi.hwrite);
--	
--	FSM:
--process(clk)
--begin
--			if rising_edge(clk) then
--						
--				if IDLE(counter)='1' then
--									if  (hsel_input ='1' and hready_input ='1' and hwrite_input= '1') then
--										
--										--addr_buffer(31 downto 20) <= (others =>'0');
--										addr_buffer(19 downto 0)  <= ahbsi.haddr(19 downto 0);
--										--data_buffer <=  (others =>'0');
--										next_state <= AHB_DATA;
--										--ahbso.hready <= '0';
--
--										
--									elsif  (hsel_input='1' and hready_input ='1' and  hwrite_input_nt = '1' ) then
--										
--										--addr_buffer(31 downto 20) <= (others =>'0');
--										addr_buffer(19 downto 0)  <= ahbsi.haddr(19 downto 0);
--										--data_buffer <=  (others =>'0');
--										next_state <= AVA_RD;
--										--ahbso.hready <= '0';
--
--										
--									else 
----										addr_buffer(31 downto 0) <= (others => '0');
--										next_state <= IDLE;
----										ahbso.hready <= '0';
----										avm_write   <=  '0';
----										avm_read    <=  '0'; 
----										avm_byteenable <= (others =>'1');
----										avm_data_wr <=   (others =>'0');
----										avm_address <=   (others =>'0');
--										
--									end if;	
--				end if;
--
--				if AHB_DATA(counter)='1' then
--				
--    								data_buffer <=  ahbsi.hwdata(31 downto 0);
----									ahbso.hready <= '0';
----									avm_write   <=  '0';
----									avm_read    <=  '0'; 
----									avm_byteenable <= (others =>'1');
----									avm_data_wr <=   (others =>'0');
----									avm_address <=   (others =>'0');
--									next_state <= AVA_WR ;
--				end if;
--
--				if AVA_WR(counter)='1' then
--										
----									avm_data_wr <=   data_buffer;
----									avm_address <=   addr_buffer; 
----									avm_write   <=   ahbsi.hwrite;
----									avm_read    <=   not ahbsi.hwrite; 
----									avm_byteenable <= (others =>'1');
----									ahbso.hrdata <=  (others =>'0');--avm_data_rd ; 
----									ahbso.hready <= '0';
--									next_state <= WAIT_STATE_WR ;
--				end if;
--
--				if WAIT_STATE_WR(counter)='1' then
--									
--									if (avm_waitrequest = '0') then
--											
--											next_state <= DONE_WR ;
--											
--											--clear all the signals involved in the transfer 
--									else 
--										   		
--											--keep all the signals constant here
----											avm_data_wr <=   data_buffer;
----											avm_address <=   addr_buffer; 
----											avm_write   <=   ahbsi.hwrite;
----											avm_read    <=   not ahbsi.hwrite; 
----											avm_byteenable <= (others =>'1');
----											ahbso.hrdata <=  (others =>'0');--avm_data_rd ; 
----											ahbso.hready <= '0';		
--											
--											next_state <= WAIT_STATE_WR ;
--									
--										 
--								   end if;
--				end if;
--				
--				if DONE_WR(counter)='1' then
--										
----										avm_write   <=  '0';
----										avm_read    <=  '0'; 
----										avm_byteenable <= (others =>'1');
----										avm_data_wr <=   (others =>'0');
----										avm_address <=   (others =>'0');
----										ahbso.hrdata <=  (others =>'0');
----										ahbso.hready <= '1';
--										next_state   <= IDLE;
--				end if;
--
--				if AVA_RD(counter)='1' then
--										
--										ahbso.hready <= '0';
--										avm_data_wr <=   (others =>'0');
--										avm_address <=   addr_buffer; 
--										avm_write   <=   ahbsi.hwrite;
--										avm_read    <=   not ahbsi.hwrite; 
--										avm_byteenable <= (others =>'1');
--										ahbso.hrdata <=  (others=> '0') ; 
--										
--										next_state <= WAIT_STATE_RD ;
--				end if;
--				
--				if WAIT_STATE_RD(counter)='1' then
--						Reg2<=mux2;
--				end if;
--				
--				if DONE_RD(counter)='1' then
--						Reg2<=mux2;
--				end if;
--				
--				
--				if (counter=5) then
--						counter<=0;
--				else
--						counter<=counter+1;
--				end if;
--			end if;
--end process;
--	

-----------------------------------------------------------------------------------------------------------------------
--																	Wrapper design using FSM (with separate DP and output logic)

-----------------------------------------------------------------------------------------------------------------------

LIBRARY IEEE;
library grlib;
USE IEEE.STD_LOGIC_1164.ALL;
use grlib.amba.all;
use grlib.stdlib.all;
use grlib.devices.all;
-----------------------------
use work.config.all;
----------------------------

entity top_level_wrapper is 
	generic (
				hindex : integer := 5;
				haddr : integer := 16#eee#;
				hmask : integer := 16#fff#
			);
 
	port(
    --clock and reset signals
		clk         :  in std_logic;
		reset       :  in std_logic;
		
		
	--AMBA side signals
		ahbsi       :  in ahb_slv_in_type; --ahb slave record input type
		ahbso       :  out ahb_slv_out_type;
		--test_out : out std_logic

					--AVALON AHB 
			avm_data_rd : in  std_logic_vector (31 downto 0);
			avm_data_wr : out   std_logic_vector (31 downto 0);
			avm_address : out   std_logic_vector (31 downto 0);
			avm_write   : out   std_logic;
			avm_read    : out   std_logic;
			avm_byteenable :out std_logic_vector(3 downto 0);
			--avm_chipselect : out std_logic;
			avm_waitrequest : in std_logic


	);

end top_level_wrapper;
--
architecture structural_top of top_level_wrapper is 

	--signals 	
--	signal hsel,hready : std_logic;
	
	signal hsel_input, hready_input, hwrite_input, hwrite_input_nt:std_logic;

-- datapath control signals

	signal addr_AHB_en, data_AHB_en, data_rd_AVA_en : std_logic;
	
-- datapath signals 

	signal addr_AHB, data_AHB, data_rd_AVA	: std_logic_vector(31 downto 0);
	
	
	--state register 
	type state_type is (IDLE,AHB_DATA,AVA_WR,WAIT_STATE_WR,DONE_WR,AVA_RD,WAIT_STATE_RD,DONE_RD);
	signal next_state,pres_state:state_type;
	
	--AHB plug and play configuration
	constant VENDOR_CONTRIB    : amba_vendor_type := 16#09#;
	constant HCONFIG: ahb_config_type := (
											0 => ahb_device_reg ( VENDOR_CONTRIB, 16#0e1#, 0, 0, 0),
										   4 => ahb_membar(haddr, '0', '0', hmask), others => zero32--X"00000000"
										 );
										 
	
begin

-- Assigning different values to AHB signals
	ahbso.hresp   <= "00"; --OKEY response from the slave 
   ahbso.hsplit  <= (others => '0'); 
-- F --	ahbso.hcache  <= '0';--'1';
   ahbso.hindex  <= hindex; --driving hindex generic back on the ahbso to the AHB controller 
  	ahbso.hconfig <= HCONFIG; -- Plug&play configuration
	ahbso.hirq <= (others =>'0'); -- No interrupt line used
	
--Assigning inputs to wires to be used in the FSM control 	
	
	hsel_input <=   ahbsi.hsel(hindex);
	hready_input <= ahbsi.hready; 
	hwrite_input <= ahbsi.hwrite;
	hwrite_input_nt <= not (ahbsi.hwrite);
	
	------------------------------------------------------------------------------------------------
	--														Next state logic
	------------------------------------------------------------------------------------------------
	
P0:	process(pres_state,hsel_input,hready_input,hwrite_input,hwrite_input_nt,avm_waitrequest)
				begin
						next_state <= pres_state;
						case pres_state is
						
								when IDLE =>
										if  (hsel_input ='1' and hready_input ='1' and hwrite_input= '1') then
										
												next_state <= AHB_DATA;
										
										elsif  (hsel_input='1' and hready_input ='1' and  hwrite_input_nt = '1' ) then
										
												next_state <= AVA_RD;
																	
										else 
												next_state <= IDLE;
										
										end if;
										

								when AHB_DATA =>
											
										next_state <= AVA_WR ;
									
								when AVA_WR => 
						
										next_state <= WAIT_STATE_WR ;
											
								when WAIT_STATE_WR =>
										
										if (avm_waitrequest = '0') then
											
												next_state <= DONE_WR ;
										else 
												next_state <= WAIT_STATE_WR ;
										end if;
											
								when DONE_WR =>
									
										next_state   <= IDLE;
									
								when AVA_RD => 
										
										next_state <= WAIT_STATE_RD ;
											
								when WAIT_STATE_RD =>
										
										if (avm_waitrequest = '0') then
											
												next_state <= DONE_RD ;
										else 
												next_state <= WAIT_STATE_RD ;		
										end if;
						
						
								when DONE_RD =>
										
										next_state   <= IDLE;	   
									

			end case;
end process;
		
		
---------------------------------------------------------------------------------------------
--													process for state register
---------------------------------------------------------------------------------------------		
regs: process(clk,reset)
begin
		if (reset='0') then-- asynchronous reset
 			 pres_state <=IDLE;
		elsif rising_edge(clk) then --(clk='1') and clk'event then
 			 pres_state <= next_state;
		end if;
end process;
--	

------------------------------------------------------------------------------------------------------------------

--													output logic and input sample logic
------------------------------------------------------------------------------------------------------------------



	avm_write  	 	 <= '1'  when   ((pres_state = AVA_WR) or (pres_state = WAIT_STATE_WR)) 				else '0';
	avm_read	 	    <= '1'  when   ((pres_state = AVA_RD) or (pres_state = WAIT_STATE_RD)) 				else '0';
	avm_byteenable  <= (others =>'1');
	ahbso.hready	 <= '1'  when   ((pres_state = DONE_WR) or (pres_state = DONE_RD)) 						else '0';
	addr_AHB_en 	 <= '1'  when   ((pres_state = IDLE) and (hsel_input ='1' and hready_input ='1')) 	else '0';
	data_AHB_en  	 <= '1'  when   (pres_state =	AHB_DATA) 															else '0';
	--data_rd_AVA_en  <= '1'  when   (pres_state = DONE_RD) 															else '0';
	data_rd_AVA_en      <= '1'  when   (pres_state = WAIT_STATE_RD) and (avm_waitrequest = '0') else '0';---(pres_state = DONE_RD) 		
	
	
------------------------------------------------------------------------------------------------------------------

--																	datapath
------------------------------------------------------------------------------------------------------------------
P1: process(clk,reset)
begin
		if (reset='0') then          -- asynchronous reset
 			
			addr_AHB 		<=	(others =>'0');
			data_AHB			<=	(others =>'0');
			data_rd_AVA		<=	(others =>'0');
			
		elsif rising_edge(clk) then --(clk='1') and clk'event then
				
				if (addr_AHB_en ='1') then 
						
						addr_AHB (31 downto 20) <=  (others => '0');
						addr_AHB (19 downto 0)  <=  ahbsi.haddr(19 downto 0);
				end if;
				
				if (data_AHB_en ='1') then 
						
						data_AHB (31 downto 0)  <=  ahbsi.hwdata(31 downto 0);
				end if;
				
				if (data_rd_AVA_en = '1') then 
				
						data_rd_AVA		<=  avm_data_rd ;   
				end if;
				
		
		end if;
end process;

	avm_address		<=	addr_AHB;		
	avm_data_wr		<=	data_AHB;		
	ahbso.hrdata   <= ahbdrivedata(data_rd_AVA);  


end architecture;




