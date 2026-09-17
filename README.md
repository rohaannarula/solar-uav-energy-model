# Solar UAV Energy Model

A MATLAB-based simulation of the energy balance of a solar-powered UAV undertaking a transatlantic flight.

The model includes:

* Great-circle navigation
* Steady-level flight aerodynamics
* Solar-position and photovoltaic modelling
* Battery state-of-charge dynamics

It investigates how cruise altitude, flight condition, solar-panel orientation and battery capacity affect long-endurance flight.

## Key features

* Comparison of maximum-\(L/D\) and minimum-power flight
* Fixed versus idealised two-axis gimballed solar panels
* Solar harvesting with atmospheric attenuation
* Time-dependent battery energy balance
* Altitude and mission-performance analysis

## Main finding

At 3000 m, maximum-\(L/D\) flight required **22.02 MJ over 123.4 hours**, while minimum-power flight required **25.75 MJ over 162.5 hours** but maintained a greater battery reserve.

Idealised solar tracking increased harvested energy by approximately **62%**, although much of this surplus was discarded once the battery reached capacity.

The results demonstrate that solar-UAV endurance is governed by the coupled relationship between **aerodynamics, solar collection and energy storage**.

## Research

This project accompanies an academic paper investigating the energy balance of a solar-powered UAV crossing the Atlantic from London Heathrow to JFK.

**Author:** Rohaan Narula
**Mentor:** Dr. Ella Atkins, Virginia Tech

## Requirements

* MATLAB
* MATLAB plotting functionality

Run the main MATLAB script to reproduce the simulation and analysis plots.
