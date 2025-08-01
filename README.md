﻿# 64--bit-QAM-Modulator-
## 📡 Overview

The 64-QAM Modulator converts a 60 Mbps data stream into 4-bit I/Q pairs at a 10 MHz symbol rate. It features:

- **64-QAM Symbol Mapping**
- **SPI Interface for Configuration**
- **Baseband Data Packet Processing**
- **Clock Domain Crossing (CDC) FIFO**
- **512-register Symbol Storage Array**
- **Reset Synchronization**

---

## 📐 Block Diagram

Core functional blocks include:

![64-QAM Block Diagram](block_diagram.png)

## 🔌 Interfaces

### Input Signals

| Signal       | Direction | Description                            |
|--------------|-----------|----------------------------------------|
| `rst_n`      | Input     | Active-low asynchronous reset          |
| `data_in`    | Input     | 60 Mbps data stream                    |
| `data_clk`   | Input     | 60 MHz clock                           |
| `sym_clk`    | Input     | 10 MHz symbol clock                    |
| `SCLK`       | Input     | SPI Clock (100 kHz)                    |
| `MOSI`       | Input     | SPI data from master                   |
| `CSN`        | Input     | SPI Chip Select (active low)          |

### Output Signals

| Signal         | Direction | Description                    |
|----------------|-----------|--------------------------------|
| `MISO`         | Output    | SPI data to master             |
| `MISO_enable`  | Output    | Enable signal for MISO output  |
| `I[3:0]`, `Q[3:0]` | Output | Mapped I/Q symbol values       |
| `new_symbol`   | Output    | Pulse to indicate new symbol   |

---

## 🧮 Serial Message Format

A 34-bit SPI message is used for configuration:

| Bits      | Field                  |
|-----------|------------------------|
| 33        | Read/Write (0 = Read)  |
| 32:23     | 10-bit Register Address|
| 22:14     | Dead Time              |
| 13:6      | 8-bit Register Data    |
| 5:0       | Dead Time              |

---

## 🗃 Symbol Storage

- 512 register locations store each I/Q symbol pair (`IIII QQQQ` format).
- Each new data packet overwrites the storage sequentially from address 0.
- Accessible via SPI interface.
