# CYW955572BTEVK-01

### Overview

The Infineon CYW955572BTEVK-01 Evaluation Kit enables you to evaluate and develop Bluetooth&#174; applications using the AIROC&#8482; CYW55572 high-performance Wi-Fi 6/6E (11ax) and Bluetooth&#174; combo. The CYW5557x product family includes an integrated Bluetooth&#174; subsystem with Arm&#174; Cortex&#174;-M33 supporting BR/EDR/Bluetooth&#174; and isochronous channels for LE audio. This kit helps evaluate, develop, and debug embdedded Bluetooth&#174; applications quickly for faster time-to-market.

### Kit Features

* AIROC&#8482; CYW55572 Wi-Fi 6 (11ax) + Bluetooth&#174; combo chip
* Audio Arduino shield with on-board analog microphones, audio codec chip, headphone, and speaker output
* On-board sensors - an ambient light sensor, thermistor, and footprint for an Infineon digital microphone
* USB connector for power, programming, and USB-UART bridge

### Kit Contents

* CYW9BTM2BASE1 base board
* CYW955572M2BT1LV radio card (mounted on the base board)
* CYW9BT Audio 3 Arduino shield
* USB Standard-A to Micro-B cable
* Power Adapter

### Additional Information

* Max UART baud rate is 3M.

## Additional Notes:
The CYW955572BTEVK-01 is used with the audio shield board and the CUSTOM button on the shield board is configured for input by default.

### ATTENTION!

The Infineon CYW955572BTEVK-01 Evaluation Kit is enabled for programming for only a few seconds after a recovery reset. For best programming results, add "UART=COMXX" (or "UART=/dev/ttyXX" for Linux or macOS) to the application makefile, replacing "UART=AUTO". Replace XX with the proper HCI port name that is attached to the kit. This will skip the serial device port scan and begin the CYW55572 device programming immediately.
