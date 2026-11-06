# CSUN ECE 520 - Lab 1: Blinking LED

## Overview
In this lab, I designed a module that blinks an LED every second on the Zybo Z7-10 development board. I then used this module to expand my design to be able to control the on-board RGB LED using 3 on-board switches. Lastly, the module was tested for functionality and timing of the blinking and the full design was tested for functionality, both using a self-checking testbench.

## Design Summary

The architecture uses a hierarchical VHDL design consisting of a lower-level parameterized counter module (`blinking_led`) and a top-level controller (`rgb_led_top`) which is then mapped to physical hardware resources on the Zybo Z7-10 development board.

*   **`blinking_led` Module**: Implements a 32-bit natural counter variable (`count_var`) evaluated on the rising edge of `sys_clk`. It features an active-high synchronous reset (`rst`) and an enable signal (`led_en`). When `rst` is asserted or `led_en` is `'0'`, `count_var` and `led_reg` clear to `0`. When enabled, the internal variable increments on each clock edge until reaching `CLK_CYCLES_PER_TOGGLE - 1`, at which point `led_reg` toggles and the counter resets. At the default generic value of `62_500_000` cycles and a `125 MHz` clock, the module achieves a toggle rate of $0.5\text{ s}$ ($1\text{ Hz}$ full blink cycle).
*   **`rgb_led_top` Top-Level Module**: Decodes the 3-bit physical switch input (`sw`) to enforce single-channel selection. Using concurrent VHDL statements, enable signals (`red_en`, `green_en`, `blue_en`) are asserted only during explicit single-bit active states:
    *   `sw = "001"` $\rightarrow$ Red Channel Enabled (`rgb_out(0)`)
    *   `sw = "010"` $\rightarrow$ Green Channel Enabled (`rgb_out(1)`)
    *   `sw = "100"` $\rightarrow$ Blue Channel Enabled (`rgb_out(2)`)
    *   Any invalid state or multi-switch input (e.g., `sw = "011"`) drives all enable lines low, turning the entire RGB LED off. Three structural instances of `blinking_led` drive the individual channels of `rgb_out`.

---

## Verification and Results

Verification was performed via simulation using the self-checking testbench `rgb_led_top_tb` utilizing `testing_pkg` from my ECE420 course created by Prof. Philip Tracton. The generic `CLK_CYCLES_PER_TOGGLE` was scaled down to `10` clock cycles to accelerate timing verification.

*   **Test Case 1 (Reset Behavior)**: Evaluated with `rst_tb = '1'` and `sw_tb = "001"`. Verified that `rgb_out_tb` remains locked to `"000"` (`0x00000000`), proving synchronous clear overrides switch input.
*   **Test Case 2 (Red Channel Activation)**: Evaluated with `rst_tb = '0'` and `sw_tb = "001"`. Observed `rgb_out_tb(0)` toggle high after 10 system clock edges, returning a matched value of `0x00000001`.
*   **Test Case 3 (Green Channel Activation)**: Evaluated with `sw_tb = "010"`. Verified that `rgb_out_tb(1)` toggles high while `rgb_out_tb(0)` drops to `'0'`, matching expected mask `0x00000002`.
*   **Test Case 4 (Blue Channel Activation)**: Evaluated with `sw_tb = "100"`. Verified `rgb_out_tb(2)` toggles high, matching expected mask `0x00000004`.
*   **Test Case 5 (Multi-Switch Disable)**: Evaluated with `sw_tb = "011"`. Confirmed that active overlap forces `rgb_out_tb` to `"000"` (`0x00000000`).

**Resource Utilization & Timing (Zybo Z7-10 / xc7z010clg400-1)**[cite: 1]:
*   **Slice LUTs**: Minimal utilization (primarily 32-bit counter registers and dynamic comparator logic per sub-block).
*   **Registers / Flip-Flops**: ~99 FFs (3 counter registers + output registers).
*   **Timing Summary**: Meets setup/hold timing requirements at a target period of $8.00\text{ ns}$ ($125\text{ MHz}$ `sys_clk_pin`)[cite: 1]. Worst Negative Slack (WNS) > $0\text{ ns}$.

---

## Known Issues or Limitations

*   **Hardware Glitch Risk on Switch Transitions**: Asynchronous physical switch toggling without internal debouncing logic can lead to invalid switch states lasting a few clock cycles, causing momentary LED disablement during manual toggling.

#