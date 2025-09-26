# 🏙️ NYC Rental Market Analysis — Impact of Local Law 18

## 📌 Project Overview

This repository analyzes the impact of New York City’s **Local Law 18 (Short-Term Rental Registration Law)** on Airbnb listings, housing availability, and rental prices.

The work includes both a **research poster** and an **R code script** that reproduces the visualizations.

---

## 📂 Repository Contents

* `NYC_Rental_Analysis_Poster.pdf` → Research poster (summary of findings).
* `analysis_code.R` → R script to load, clean, and visualize the data.

---

## 🏠 Context

* In **2023**, NYC’s rental vacancy rate fell to **1.41%** — the lowest in 56 years.
* **Local Law 18** (effective Sept 2023) required Airbnb/short-term rental hosts to register with the city, live in the unit, and limit rentals.
* By **2024**, Airbnb listings had dropped by **87%** compared to 2019.

---

## 📊 Key Findings

* **Listings**: Over **11,000 Airbnb units** disappeared (2019–2024).
* **Economic Impact**:

  * $2.5B in annual guest spending lost.
  * Brooklyn (-$977M) and Manhattan (-$889M) were hardest hit.
  * More than **21,000 jobs affected**.
* **Housing**: Renter-occupied units increased **7% (2021–2023)**.
* **Rents**: Median rents in Manhattan, Brooklyn, and Queens **continued to rise** even after the crackdown.

---

## 📈 Code Highlights

The R script (`analysis_code.R`) generates:

1. 📉 Airbnb Listings Decline (2019–2024) — with % change annotations
2. 🏘 Listings by Borough (2019 vs 2023/24) — pre vs post LL18
3. ⏳ Rental Duration Analysis (<30 nights vs ≥30 nights)
4. 💵 Median Rent Trends (2010–2025) — with policy enforcement marker
5. 📊 NYC Rental Vacancy Rates (1975–2023) — long-term perspective
6. 🍩 Airbnb Guest Spending Loss by Borough — donut chart
7. 🥧 Citywide Rentals vs Airbnb Proportion (2023) — pie chart

*All plots built using **dplyr**, **tidyr**, and **ggplot2**.*

---

## 📑 Data Sources

* Inside Airbnb
* AirDNA
* Airbnb Newsroom
* Booking.com, VRBO
* Zillow
* Reuters
* NYC Housing and Vacancy Survey
* NYS Office of Special Enforcement

---

## 🚀 How to Run

1. Clone the repo:

   ```bash
   git clone https://github.com/<your-username>/<repo-name>.git
   cd <repo-name>
   ```
2. Open `Poster code.R` in RStudio (or run in R).
3. Update dataset paths if needed (see script comments).
4. Run the script to generate all figures.

---

