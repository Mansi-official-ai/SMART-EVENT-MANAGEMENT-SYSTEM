# Smart Event Management System

A MySQL database project for managing events, venues, organizers, attendees, ticket bookings, and payments.

## Project Objective

Develop a Smart Event Management System using MySQL. The database supports event management, attendee registration, ticket booking, payment tracking, and report generation using SQL queries.

## Features

- Create, read, update, delete, and search event records (CRUD).
- Filter records using `WHERE`, `HAVING`, and `LIMIT`.
- Apply logical operators: `AND`, `OR`, and `NOT`.
- Sort and group data using `ORDER BY` and `GROUP BY`.
- Generate summaries using `SUM()`, `AVG()`, `MAX()`, `MIN()`, and `COUNT()`.
- Connect tables using primary keys and foreign keys.
- Retrieve related information using joins.
- Use subqueries for reporting.
- Apply date/time and string functions.

## Database Tables

The project contains six tables:

| Table | Purpose |
|---|---|
| `Venues` | Venue name, location, and capacity |
| `Organizers` | Organizer names and contact details |
| `Attendees` | Attendee names and contact details |
| `Events` | Event dates, venue, organizer, prices, and seat availability |
| `Tickets` | Ticket bookings and booking status |
| `Payments` | Payment amounts, status, and payment dates |

### Main Relationships

- `Events.venue_id` references `Venues.venue_id`.
- `Events.organizer_id` references `Organizers.organizer_id`.
- `Tickets.event_id` references `Events.event_id`.
- `Tickets.attendee_id` references `Attendees.attendee_id`.
- `Payments.ticket_id` references `Tickets.ticket_id`.
- A unique constraint on `(event_id, attendee_id)` prevents the same attendee from booking the same event more than once.

## Requirements

- MySQL Server
- MySQL Workbench or the MySQL command-line client

## How to Run

1. Open MySQL Workbench or your MySQL command-line client.
2. Open the supplied SQL script: `Smart_Event_Management_System_Corrected (1).sql`.
3. Execute the complete script. It creates the `SmartEventDB` database, creates the six tables, and inserts sample data.
4. Run the queries in the script one by one to inspect their results.
5. Use `Smart_Event_Management_System_Answers.txt` for the questions, SQL answers, expected output examples, and reasons.

> **Important:** The SQL script starts with `DROP DATABASE IF EXISTS SmartEventDB;`. Running it again deletes and recreates that database, including any changes you made to its data. Back up any work you need before rerunning it.

## SQL Topics Demonstrated

1. CRUD operations
2. `WHERE`, `HAVING`, and `LIMIT`
3. `AND`, `OR`, and `NOT`
4. `ORDER BY` and `GROUP BY`
5. Aggregate functions: `SUM`, `AVG`, `MAX`, `MIN`, `COUNT`
6. Primary keys, foreign keys, and unique constraints
7. `INNER JOIN`, `LEFT JOIN`, and `RIGHT JOIN`
8. Subqueries
9. Date functions: `MONTH()`, `DATEDIFF()`, `DATE_FORMAT()`
10. String functions: `UPPER()`, `TRIM()`, `COALESCE()`

## Notes

- The expected outputs in the answers file are based on the sample data in the SQL script.
- Queries using `CURDATE()` or `NOW()` may return different results on different dates.
- MySQL does not directly support `FULL OUTER JOIN`; the supplied SQL demonstrates a `LEFT JOIN` approach for finding attendees without bookings.
- The `payment_date` column in the supplied schema is a `DATE`, so it stores a date rather than a time-of-day value.

## Project Files

- `Smart_Event_Management_System_Corrected (1).sql` — database schema, sample data, and SQL practice queries.
- `Smart_Event_Management_System_Answers.txt` — questions, SQL answers, expected outputs, and explanations.
- `README.md` — project overview and run instructions.

## Learning Outcome

This project provides practice in designing a relational database, defining table relationships, writing SQL queries, and generating reports from event and payment data.
