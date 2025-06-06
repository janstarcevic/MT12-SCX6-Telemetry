# MT12-SCX6 Telemetry

A custom Lua dashboard for the RadioMaster MT12 transmitter, designed specifically for the Axial SCX6 but simply customizable for other RC vehicles.

**Features:**
- Real-time display of battery voltage, average cell voltage, and run time
- Model name either "waiting for power" or "running on" cell count (calculates battery cells) and clock
- Bold, center-focused average cell voltage readout for quick glances
- Text-based voltage bar/gradient for intuitive battery status
- Custom alerts and threshold warnings for low voltage
- Drive Modes indication (based on the stock DX3 and upgraded to text labels)
- Clean, readable layout for the MT12’s 128x64 LCD screen
- Configurable for telemetry-capable ESCs or external voltage sensors
- Voltage calibration offset

**Optional - Possible to Add Features:**
- “ARMED/DISARMED” status indicator (compatible with CH5 arming logic)

- Open source, MIT licensed

## Installation

1. Edit "capacity_mAh" based on your battery capacity.
2. Edit "modelName" based on your model name.
3. Edit "avgCurrentA" based on your model's power draw (depending on your usage, such as crawling/bashing, etc. - keep 8 for combined usage)
4. Measure the real voltage and adjust voltage calibration offset (you can do this in the script or directly on your MT12).
5. Copy the `.lua` script file into the `/SCRIPTS/TELEMETRY/` directory on your MT12 SD card.
6. Assign telemetry sensor for voltage (use "BATT") for your voltage wire lead.
7. Activate the script from the Telemetry menu on your MT12.

## Usage

- The dashboard will automatically show real-time voltage, cell status, drive mode, and more.

## Screenshots

*Coming soon!*

## Contributing

Contributions, bug reports, and suggestions are welcome!  
Fork this repository, open a pull request, or submit an issue.

## License

MIT License — free to use, modify, and distribute.

---
