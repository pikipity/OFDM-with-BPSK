# Simulation: OFDM System with BPSK Modulation

Simulate the OFDM system with BPSK modulation method and plot the figure of BER vs. SNR.

## Optional Inputs

1. BitPerSymbol: Bits per symbol, default is 1
2. NoSymbol: Number of symbols, default is 10^6
3. NoSub: Number of subcarriers, default is 64
4. LenCyclic: Length of cyclic prefix, default is 16
5. SNR: SNR range for simulations, default is 0:2:30
6. BPSKNum: Number of phase for BPSK, default is 2. Mapping the bit 0 and the bit 1 as -1 and 1

## Example

`BER_vs_SNR_OFDM_with_BPSK('NoSymbols',10^6,'SNR',0:15);`

## Simulation Results

Parameters are all default values

![Simulation Results](https://raw.githubusercontent.com/pikipity/OFDM-with-BPSK/master/Simulation%20Results/Simulation%20Results.png)

![Theoretical Results](https://github.com/pikipity/OFDM-with-BPSK/blob/master/Simulation%20Results/Theory%20Results.png)

![Compare](https://raw.githubusercontent.com/pikipity/OFDM-with-BPSK/master/Simulation%20Results/Compare.png)
