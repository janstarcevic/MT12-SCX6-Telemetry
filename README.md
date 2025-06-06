# MT12-SCX6 Telemetry

A custom Lua dashboard for the RadioMaster MT12 transmitter, designed specifically for the Axial SCX6 but simply customizable for other RC vehicles.

**Features:**
- Real-time display of battery voltage, average cell voltage, and run time
- Intelligent model name display: "needs power" or "on" cell count (calculates battery cells)
- Real-time clock
- Bold, center-focused average cell voltage readout for quick reference
- Text-based voltage bar/gradient for intuitive battery status
- Custom alerts and low voltage warnings for maximum pack safety (before ESC low voltage cut-off)
- Drive Modes indication (based on the stock DX3 and upgraded to text labels)
- Clean, readable layout for the MT12’s 128x64 LCD screen
- Configurable for telemetry-capable ESCs or external voltage sensors
- Voltage calibration offset for precise accuracy
- Open source, MIT licensed

## Installation

1. Edit the script to match your model:
- Set capacity_mAh to your battery’s capacity
- Set modelName to your preferred vehicle name
- Set avgCurrentA to your model’s typical current draw (8 is a good starting point)
2. Measure real voltage and adjust the CALIBRATION_OFFSET if needed (in the script or on the MT12)
3. Copy the `.lua` script file into the `/SCRIPTS/TELEMETRY/` directory on your MT12 SD card.
4. Assign telemetry sensor for voltage (use Vbat as "BATT") for your voltage wire lead.
5. Activate the script from the Telemetry menu on your MT12.

## Usage

Hit Telemetry button to display live voltage, average cell voltage, runtime, drive mode, and more at a glance.

## Screenshots

*Coming soon!*

## Contributing

Contributions, bug reports, and suggestions are welcome!  
Fork this repository, open a pull request, or submit an issue.

## License

MIT License — free to use, modify, and distribute.

---
