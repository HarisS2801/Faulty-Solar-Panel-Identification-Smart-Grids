# Faulty Solar Panel Identification in Smart Grids

> An intelligent photovoltaic (PV) fault identification and classification system developed using **MATLAB/Simulink** to automatically detect, locate, and classify faulty solar panels in smart grid environments.

![MATLAB](https://img.shields.io/badge/MATLAB-R2024a-blue)
![Simulink](https://img.shields.io/badge/Simulink-Modeling-orange)
![Status](https://img.shields.io/badge/Project-Completed-success)
![University](https://img.shields.io/badge/University-University%20of%20Jaffna-green)
![License](https://img.shields.io/badge/License-MIT-yellow)

---

# Project Overview

Photovoltaic (PV) systems are increasingly integrated into modern smart grids. However, faults such as open circuits, bypass diode failures, partial shading, and module degradation can significantly reduce energy generation and system reliability.

This project presents an intelligent fault diagnosis system capable of automatically detecting, locating, and classifying faults within a photovoltaic array using electrical parameter analysis and the **String Health Index (SHI)**.

The proposed methodology accurately distinguishes between electrical faults and environmental effects such as partial shading while identifying the affected PV module and string.

---

# Objectives

- Develop a photovoltaic array model using MATLAB/Simulink
- Detect abnormal operating conditions automatically
- Calculate String Health Index (SHI)
- Identify faulty PV strings
- Locate the faulty solar panel
- Differentiate partial shading from electrical faults
- Improve fault diagnosis accuracy while reducing manual inspection

---

# System Architecture

```
              Solar Irradiance
                     │
                     ▼
          Photovoltaic Array (3S2P)
                     │
                     ▼
        Voltage / Current Measurement
                     │
                     ▼
      SHI Calculation & Signal Analysis
                     │
                     ▼
      Fault Detection Algorithm
                     │
                     ▼
   Fault Classification & Localization
                     │
                     ▼
          Diagnostic Output
```

---

# Features

- Intelligent PV fault detection
- Automatic fault localization
- String Health Index (SHI) computation
- Electrical parameter monitoring
- Steady-state signal analysis
- Fault classification
- Partial shading discrimination
- Automatic identification of faulty PV module
- Automatic identification of faulty string

---

# Fault Types Identified

The developed system detects and classifies:

- Open-Circuit Fault
- Bypass Diode Short-Circuit Fault
- Line-to-Ground Fault
- Partial Shading
- Module Underperformance
- PV Module Degradation

---

# Methodology

The implemented workflow consists of the following stages:

1. Build a photovoltaic array model in MATLAB/Simulink.
2. Measure electrical parameters:
   - Voltage
   - Current
   - Irradiance
   - Temperature
3. Calculate the String Health Index (SHI).
4. Analyze steady-state operating conditions.
5. Detect abnormal behavior.
6. Classify the fault type.
7. Locate the faulty string.
8. Identify the faulty PV module.

---

# Technologies Used

| Category | Technologies |
|----------|--------------|
| Programming | MATLAB |
| Simulation | Simulink |
| Domain | Smart Grid |
| Renewable Energy | Photovoltaic Systems |
| Analysis | Signal Processing |
| Fault Diagnosis | SHI-Based Analysis |

---

# Results

The developed system successfully:

- Detected faulty PV strings
- Located faulty PV modules
- Classified electrical faults
- Distinguished partial shading from electrical faults
- Reduced false fault detection
- Improved diagnosis reliability using SHI

---

# Sample Output

Insert screenshots such as:

- Open Circuit Detection
- SHI Plot
- Current Waveform
- Voltage Waveform
- Fault Localization Result

---

# Project Highlights

- Intelligent fault diagnosis
- Automatic fault localization
- Renewable energy application
- Smart Grid implementation
- MATLAB/Simulink modeling
- Electrical signal analysis
- Practical engineering solution

---

# My Contributions

- Designed the complete PV fault diagnosis methodology
- Developed the MATLAB algorithms
- Built the Simulink PV array model
- Implemented SHI calculation
- Designed the fault detection algorithm
- Developed the fault classification logic
- Validated the system under multiple fault conditions
- Performed testing and result analysis

---

# Skills Demonstrated

- MATLAB Programming
- Simulink Modeling
- Smart Grid Technologies
- Photovoltaic Systems
- Renewable Energy Systems
- Signal Processing
- Fault Diagnosis
- Data Analysis
- Engineering Simulation
- Electrical Power Systems

---

# Future Improvements

Future enhancements may include:

- Machine Learning-based fault classification
- Deep Learning fault prediction
- IoT-enabled real-time monitoring
- SCADA integration
- Cloud-based monitoring dashboard
- Digital Twin implementation

---

# Academic Information

**Project Title**

Faulty Solar Panel Identification in Smart Grids

**Institution**

University of Jaffna

**Project Duration**

February 2026 – April 2026

---

# Author

**Haris Sahayarajah**

Final Year Undergraduate

Department of Electrical and Electronic Engineering

University of Jaffna
