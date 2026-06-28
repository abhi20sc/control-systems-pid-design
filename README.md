# ES3C8 Group Project — Control Systems Design (MATLAB & Simulink)

> **Group project** for the ES3C8 module at the University of Warwick.
> I designed the full controller for both **Part B** and **Part C**.

---

## Project Overview

Design and tuning of feedback controllers for a Quanser servo plant, modelled by the transfer function:

```
          45s² + 0.66s + 5200
Gθ(s) = ───────────────────────────
        s⁴ + 13s³ + 240s² + 1250s
```

Controllers were designed analytically in MATLAB and validated in Simulink against the physical plant model.

---

## My Contributions

### Part B — PID Controller Design

Analytic tuning of a PID controller using frequency-response methods. Computed the proportional gain from a target crossover frequency, then derived the integral and derivative constants, evaluating gain and phase margins for stability.

### Part C — Lead Compensator Design

Designed a lead compensator to achieve a target phase margin of 55°. Computed the required phase boost, the alpha parameter, and the compensator break frequencies, then validated the closed-loop response.

---

## Repository Contents

- **`PARTB/`** — MATLAB design script and Simulink models (`.slx`) for the PID controller
- **`PARTC/`** — MATLAB design script and Simulink models (`.slx`) for the lead compensator
- **`MODELTESTVIDEO.mp4`** — Demo video of the working model
- **`Group3_ES3C8_report.pdf`** — Full group report

---

## Technologies

- MATLAB (Control System Toolbox)
- Simulink
- Quanser hardware plant model

---

## Module Context

**ES3C8 — Control Systems**, University of Warwick, Year 3 (2025–26)
