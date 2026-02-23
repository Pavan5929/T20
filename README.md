🏏 T20 International Cricket Data Analysis (2024)
📌 Project Overview

This project analyzes T20 International cricket matches played in 2024 using MySQL.
The goal is to extract meaningful insights from structured match data using advanced SQL queries.

The dataset contains match-level information including:

Team1

Team2

Winner

Winning Margin

Match Date

Ground

🗄️ Database Schema
CREATE TABLE T20I (
    Team1 VARCHAR(50),
    Team2 VARCHAR(50),
    Winner VARCHAR(50),
    Margin VARCHAR(50),
    MatchDate DATE,
    Ground VARCHAR(50)
);
🔎 Key Analysis Performed
1️⃣ Matches Between Specific Teams (2024)

Filtered matches played between two specific teams using conditional logic and date filtering.

2️⃣ Team with Highest Wins in 2024

Used:

GROUP BY

COUNT()

ORDER BY

LIMIT

3️⃣ Ranking Teams by Wins

Used:

DENSE_RANK() window function

Aggregations

Filtering out ties and no results

4️⃣ Highest Average Winning Margin (Runs)

Performed:

String extraction using SUBSTRING() and INSTR()

AVG() aggregation

Margin filtering (LIKE '%runs')

5️⃣ Matches Above Average Margin

Used:

Common Table Expression (CTE)

Comparison with overall average margin

6️⃣ Best Chasing Team (Wins by Wickets)

Identified teams with most wins while chasing using:

RANK() window function

Margin filtering (LIKE '%wickets')

🛠️ SQL Concepts Used

Aggregation Functions (COUNT, AVG)

Window Functions (RANK, DENSE_RANK)

Common Table Expressions (CTE)

String Manipulation

Date Filtering (YEAR())

Conditional Filtering

Analytical Query Design

📊 Learning Outcomes

Strengthened SQL query writing skills

Practiced real-world analytical problem solving

Worked with sports performance data

Implemented ranking and statistical comparison logic

🚀 Future Improvements

Add Power BI / Tableau dashboard

Convert margin column to structured numeric format

Build visualization layer

Deploy as analytics dashboard

👨‍💻 Author

Pavan Arravali
B.Tech CSE | SQL & Data Analytics Enthusiast
