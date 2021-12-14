#
# Copyright 2016-2021, Cypress Semiconductor Corporation (an Infineon company) or
# an affiliate of Cypress Semiconductor Corporation.  All rights reserved.
#
# This software, including source code, documentation and related
# materials ("Software") is owned by Cypress Semiconductor Corporation
# or one of its affiliates ("Cypress") and is protected by and subject to
# worldwide patent protection (United States and foreign),
# United States copyright laws and international treaty provisions.
# Therefore, you may use this Software only as provided in the license
# agreement accompanying the software package from which you
# obtained this Software ("EULA").
# If no EULA applies, Cypress hereby grants you a personal, non-exclusive,
# non-transferable license to copy, modify, and compile the Software
# source code solely for use in connection with Cypress's
# integrated circuit products.  Any reproduction, modification, translation,
# compilation, or representation of this Software except as specified
# above is prohibited without the express written permission of Cypress.
#
# Disclaimer: THIS SOFTWARE IS PROVIDED AS-IS, WITH NO WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, NONINFRINGEMENT, IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. Cypress
# reserves the right to make changes to the Software without notice. Cypress
# does not assume any liability arising out of the application or use of the
# Software or any product or circuit described in the Software. Cypress does
# not authorize its products for use in any products where a malfunction or
# failure of the Cypress product may reasonably be expected to result in
# significant property damage, injury or death ("High Risk Product"). By
# including Cypress's product in a High Risk Product, the manufacturer
# of such system or application assumes all risk of such use and in doing
# so agrees to indemnify Cypress against all liability.
#

ifeq ($(WHICHFILE),true)
$(info Processing $(lastword $(MAKEFILE_LIST)))
endif

#
# Device definition
#
DEVICE=CYW55572MIFFBGT
CHIP=55572
CHIP_REV?=A1
BLD=A

# CSP baselib and BSP path variables
CY_TARGET_DEVICE?=$(CHIP)$(CHIP_REV)
CY_APP_PATCH_LIBS+=$(CY_$(CY_TARGET_DEVICE)_APP_PATCH_LIBS)
COMPONENTS+=$(CY_TARGET_DEVICE) $(COMPONENTS_$(CY_TARGET_DEVICE))
ifeq ($(SEARCH_$(CY_TARGET_DEVICE)),)
# internal only - app deploys will always initialize this in mtb.mk
SEARCH_$(CY_TARGET_DEVICE)?=$(IN_REPO_BTSDK_ROOT)/wiced_btsdk/dev-kit/baselib/$(CY_TARGET_DEVICE)
SEARCH+=$(SEARCH_$(CY_TARGET_DEVICE))
endif
CY_BSP_PATH?=$(SEARCH_TARGET_$(TARGET))
# ensure the baselib has been instantiated (in case make getlibs had already been performed, but for a BSP with a different CSP
ifneq ("$(wildcard $(SEARCH_$(CY_TARGET_DEVICE))/COMPONENT_$(CY_TARGET_DEVICE))","")
CY_BASELIB_PATH?=$(SEARCH_$(CY_TARGET_DEVICE))/COMPONENT_$(CY_TARGET_DEVICE)
CY_BASELIB_CORE_PATH?=$(SEARCH_core-make)
CY_INTERNAL_BASELIB_PATH?=$(patsubst %/,%,$(CY_BASELIB_PATH))
override CY_DEVICESUPPORT_SEARCH_PATH:=$(call CY_MACRO_SEARCH,devicesupport.xml,$(CY_INTERNAL_BASELIB_PATH))
endif

# declare which stack version to use in COMPONENT folders
COMPONENTS+=btstack_v3
DISABLE_COMPONENTS+=gatt_utils_lib

#
# Define the features for this target
#
KITPROG3_BRIDGE=1

# No FLASH on this board
# Begin address of flash0, off-chip sflash
#CY_FLASH0_BEGIN_ADDR=0xFF000000
# Available flash = 4 Mb, 512k x 8
#CY_FLASH0_LENGTH=0x00080000

# Entry-point symbol for application
CY_CORE_APP_ENTRY:=spar_crt_setup

#
# TARGET UART parameters
#
# Max. supported baudrate by this platform
CY_CORE_DEFINES+=-DHCI_UART_MAX_BAUD=3000000
# default baud rate is 3M, that is the max supported on macOS
CY_CORE_DEFINES+=-DHCI_UART_DEFAULT_BAUD=3000000

#
# TARGET swd interface setup
#
# TBD for this board
ifeq ($(ENABLE_DEBUG),1)
CY_CORE_DEFINES+=-DSWD_CLK=SWDCK_ON_P11
CY_CORE_DEFINES+=-DSWD_IO=SWDIO_ON_P15
endif

# Use generated platform button configurations.
CY_CORE_DEFINES+=-DUSE_PLATFORM_BUTTON_CONFIG

#
# Patch variables
#
LIFE_CYCLE_STATE?=DM
CY_CORE_PATCH_DIR=$(CY_INTERNAL_BASELIB_PATH)/internal/$(CY_TARGET_DEVICE)/patches/fcbga_iPA_dLNA/$(LIFE_CYCLE_STATE)
CY_CORE_PATCH=$(CY_CORE_PATCH_DIR)/patch.elf
CY_CORE_PATCH_CERT=$(CY_CORE_PATCH_DIR)/patch_cert.hex
CY_CORE_PATCH_SEC_XIP_MDH=$(CY_CORE_PATCH_DIR)/patch_sec_xip.mdh
CY_CORE_PATCH_SEC=$(CY_CORE_PATCH_DIR)/patch_sec.bin
CY_CORE_PATCH_SEC_HEX=$(CY_CORE_PATCH_DIR)/patch_sec.hex
CY_CORE_PATCH_FW=$(CY_CORE_PATCH_DIR)/patch_fw.bin
CY_CORE_PATCH_CFLAGS=$(CY_INTERNAL_BASELIB_PATH)/internal/$(CY_TARGET_DEVICE)/gcc/$(CY_TARGET_DEVICE).cflag
CY_CORE_PATCH_LIB_PATH=libraries/prebuilt

#
# Variables for pre-build and post-build processing
#
CY_CORE_HDF=$(CY_INTERNAL_BASELIB_PATH)/internal/$(CY_TARGET_DEVICE)/configdef$(CY_TARGET_DEVICE).hdf
CY_CORE_HCI_ID=$(CY_INTERNAL_BASELIB_PATH)/platforms/IDFILE.txt
CY_CORE_CGSLIST+=$(CY_INTERNAL_BASELIB_PATH)/platforms/platform.cgs
CY_CORE_BTP=$(CY_INTERNAL_BASELIB_PATH)/platforms/ram.btp
ifneq ($(LIFE_CYCLE_STATE),DM)
  CY_CORE_MINIDRIVER=$(CY_INTERNAL_BASELIB_PATH)/platforms/minidriver.hex
else
  CY_CORE_MINIDRIVER=$(CY_INTERNAL_BASELIB_PATH)/platforms/secure_loader_dm.hex
endif

CY_CORE_LD_DEFS+=NUM_PATCH_ENTRIES=0

DISABLE_COMPONENTS += bsp_design_modus #it will remove when cycfg_pins.c is correct

#
# read in BTP file as single source of flash layout information
#
define \n


endef

define extract_btp_file_value
$(patsubst $1=%,%,$(filter $1%,$2))
endef

# these make targets do not need this data and don't work if importing an app
# that has not yet run make getlibs, so skip it
ifeq ($(filter import_deps getlibs get_app_info,$(MAKECMDGOALS)),)

# override core-make buggy CY_SPACE till it's fixed
CY_EMPTY=
CY_SPACE=$(CY_EMPTY) $(CY_EMPTY)

# split up btp file into "x=y" text
CY_BT_FILE_TEXT:=$(shell cat -e $(CY_CORE_BTP))
CY_BT_FILE_TEXT:=$(subst $(CY_SPACE),,$(CY_BT_FILE_TEXT))
CY_BT_FILE_TEXT:=$(subst ^M,,$(CY_BT_FILE_TEXT))
CY_BT_FILE_TEXT:=$(patsubst %$(\n),% ,$(CY_BT_FILE_TEXT))
CY_BT_FILE_TEXT:=$(subst $$,$(CY_SPACE),$(CY_BT_FILE_TEXT))

ifeq ($(CY_BT_FILE_TEXT),)
$(error Failed to parse BTP variables from file: $(CY_CORE_BTP))
endif

SS_LOCATION = $(call extract_btp_file_value,DLConfigSSLocation,$(CY_BT_FILE_TEXT))
VS_LOCATION = $(call extract_btp_file_value,DLConfigVSLocation,$(CY_BT_FILE_TEXT))
VS_LENGTH = $(call extract_btp_file_value,DLConfigVSLength,$(CY_BT_FILE_TEXT))
DS_LOCATION = $(call extract_btp_file_value,ConfigDSLocation,$(CY_BT_FILE_TEXT))

PLATFORM_DIRECT_LOAD_BASE_ADDR = $(SS_LOCATION)

endif # end filter import_deps getlibs get_app_info
