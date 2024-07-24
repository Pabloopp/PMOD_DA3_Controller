
Input/Output Configuration:
	The 16 switches on the board are used to determine the value to be converted, with each switch representing a bit.
	The top button serves as the enable signal, while the middle button is used as the reset.
	LED0 is used to display the "ready" output signal.
	The PMOD DA3 is connected to the "bottom" row of the PMOD JA pins.

Clock Requirements:
	The Basys3 board provides a 100MHz clock, but the PMOD DA3 supports a maximum clock frequency of 50MHz. Therefore, the board's clock must be divided by 2.

State Machine Design:
	The module operates based on a three-state machine: idle, send, and convert.
	Clock division and input signal synchronization are handled within the same process but independently of the state machine.

State Descriptions (overview):
	Idle State:
		The controller waits for the enable signal to send new data to the PMOD DA3.
		Upon receiving the enable signal, the current data input is stored, and the state machine transitions to the send state.

	Send State:
		In this state, data is transmitted. Once all the data has been sent, the state machine moves to the convert state.

	Convert State:
		This state manages the LDAC signal, since the LDAC signal has to be set to 0 at least half a clock period before the CS signal is set back to 1.
		After completing the process, the state machine returns to the idle state.

	The asyncronous reset signal clears any signal or state and sets them at its initial value.

	For a detailed view of the process, refer to the ASM diagram attached in the repository named ASM_DAQ_CONTROLLER.png.

Test Bench:
	Three test cases have been conducted to verify the functionality of the controller.
	Normal Data Transmission:
		The first test ensured that a standard data transmission operates correctly.
	Data Change After Enable:
		The second test involved changing the input data value after the enable signal was asserted. It was verified that the transmitted data remained the same as it was at the moment the enable signal was received. This confirms the correctness of data latching.
	Reset During Data Transmission:
		The final test examined the behavior when a reset signal is asserted during data transmission. It was observed that the state machine correctly returned to the initial state, confirming proper reset functionality.
