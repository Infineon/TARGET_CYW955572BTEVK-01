/*
 * Copyright 2016-2022, Cypress Semiconductor Corporation (an Infineon company) or
 * an affiliate of Cypress Semiconductor Corporation.  All rights reserved.
 *
 * This software, including source code, documentation and related
 * materials ("Software") is owned by Cypress Semiconductor Corporation
 * or one of its affiliates ("Cypress") and is protected by and subject to
 * worldwide patent protection (United States and foreign),
 * United States copyright laws and international treaty provisions.
 * Therefore, you may use this Software only as provided in the license
 * agreement accompanying the software package from which you
 * obtained this Software ("EULA").
 * If no EULA applies, Cypress hereby grants you a personal, non-exclusive,
 * non-transferable license to copy, modify, and compile the Software
 * source code solely for use in connection with Cypress's
 * integrated circuit products.  Any reproduction, modification, translation,
 * compilation, or representation of this Software except as specified
 * above is prohibited without the express written permission of Cypress.
 *
 * Disclaimer: THIS SOFTWARE IS PROVIDED AS-IS, WITH NO WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, NONINFRINGEMENT, IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. Cypress
 * reserves the right to make changes to the Software without notice. Cypress
 * does not assume any liability arising out of the application or use of the
 * Software or any product or circuit described in the Software. Cypress does
 * not authorize its products for use in any products where a malfunction or
 * failure of the Cypress product may reasonably be expected to result in
 * significant property damage, injury or death ("High Risk Product"). By
 * including Cypress's product in a High Risk Product, the manufacturer
 * of such system or application assumes all risk of such use and in doing
 * so agrees to indemnify Cypress against all liability.
 */

#include <wiced_platform.h>

#define cr_pad_fcn_ctl_adr2                  0x8fa30090
#define cr_pad_config_adr5                   0x8fa3007c
#define cr_pad_fcn_ctl_adr3                  0x8fa301a8
#define cr_pad_config_adr8                   0x8fa30110

#define REG32(address) (*(volatile uint32_t*)(address))

void wiced_platform_target_puart_init(void)
{
#ifdef PLATFORM_PUART_FROM_HCI_UART
    /* Select PUART function for the BT_UART_TXD pin. */
    REG32(cr_pad_fcn_ctl_adr2) &= ~(0x0000f000);
    REG32(cr_pad_fcn_ctl_adr2) |= 0x00005000;
    REG32(cr_pad_config_adr5) &= ~(0xff000000);
    REG32(cr_pad_config_adr5) |= 0x08000000;
#else
    /* Configure BT_I2S_CLK to UART2_TXD for testing */
    REG32(cr_pad_fcn_ctl_adr3) &= ~(0x0000F000);
    REG32(cr_pad_fcn_ctl_adr3) |= 0x0000B000;
    REG32(cr_pad_config_adr8) &= ~(0xFF000000);
    REG32(cr_pad_config_adr8) |= 0x08000000;
#endif
}
