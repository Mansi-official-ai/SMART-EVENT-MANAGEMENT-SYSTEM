-- SMART EVENT MANAGEMENT SYSTEM
-- MySQL Project / Exam Practice
-- Run this script in MySQL Workbench or MySQL command line.

DROP DATABASE IF EXISTS SmartEventDB;
CREATE DATABASE SmartEventDB;
USE SmartEventDB;

-- 1. TABLES
CREATE TABLE Venues (
    venue_id INT PRIMARY KEY AUTO_INCREMENT,
    venue_name VARCHAR(100) NOT NULL,
    location VARCHAR(100) NOT NULL,
    capacity INT NOT NULL CHECK (capacity > 0)
);

CREATE TABLE Organizers (
    organizer_id INT PRIMARY KEY AUTO_INCREMENT,
    organizer_name VARCHAR(100) NOT NULL,
    contact_email VARCHAR(100) UNIQUE,
    phone_number VARCHAR(20)
);

CREATE TABLE Attendees (
    attendee_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone_number VARCHAR(20)
);

CREATE TABLE Events (
    event_id INT PRIMARY KEY AUTO_INCREMENT,
    event_name VARCHAR(120) NOT NULL,
    event_date DATE NOT NULL,
    venue_id INT NOT NULL,
    organizer_id INT NOT NULL,
    ticket_price DECIMAL(10,2) NOT NULL CHECK (ticket_price >= 0),
    total_seats INT NOT NULL CHECK (total_seats > 0),
    available_seats INT NOT NULL CHECK (available_seats >= 0),
    CONSTRAINT fk_event_venue FOREIGN KEY (venue_id) REFERENCES Venues(venue_id),
    CONSTRAINT fk_event_organizer FOREIGN KEY (organizer_id) REFERENCES Organizers(organizer_id),
    CHECK (available_seats <= total_seats)
);

CREATE TABLE Tickets (
    ticket_id INT PRIMARY KEY AUTO_INCREMENT,
    event_id INT NOT NULL,
    attendee_id INT NOT NULL,
    booking_date DATE DEFAULT (CURRENT_DATE),
    status ENUM('Confirmed','Cancelled','Pending') DEFAULT 'Pending',
    CONSTRAINT fk_ticket_event FOREIGN KEY (event_id) REFERENCES Events(event_id),
    CONSTRAINT fk_ticket_attendee FOREIGN KEY (attendee_id) REFERENCES Attendees(attendee_id),
    CONSTRAINT uq_attendee_event UNIQUE (event_id, attendee_id)
);

CREATE TABLE Payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    ticket_id INT NOT NULL,
    amount_paid DECIMAL(10,2) NOT NULL CHECK (amount_paid >= 0),
    payment_status ENUM('Success','Failed','Pending','Refunded') DEFAULT 'Pending',
    payment_date DATE DEFAULT (CURRENT_DATE),
    CONSTRAINT fk_payment_ticket FOREIGN KEY (ticket_id) REFERENCES Tickets(ticket_id)
);
-- 2. SAMPLE DATA
INSERT INTO Venues (venue_name, location, capacity) VALUES
('City Convention Hall','Surat',500),
('Riverfront Arena','Ahmedabad',1000),
('Knowledge Auditorium','Vadodara',300),
('Ocean View Ground','Mumbai',800);

INSERT INTO Organizers (organizer_name,contact_email,phone_number) VALUES
('Aarav Events','aarav@example.com','9876500001'),
('Bright Star','bright@example.com','9876500002'),
('Creative Minds','creative@example.com','9876500003'),
('Event Hub','hub@example.com','9876500004');

INSERT INTO Attendees (name,email,phone_number) VALUES
('Mansi Tanwar','mansi@example.com','9000000001'),
('Rahul Shah','rahul@example.com','9000000002'),
('Priya Patel','priya@example.com','9000000003'),
('Aman Verma','aman@example.com','9000000004'),
('Neha Joshi','neha@example.com','9000000005'),
('Karan Mehta','karan@example.com','9000000006'),
('Isha Desai','isha@example.com','9000000007');

INSERT INTO Events
(event_name,event_date,venue_id,organizer_id,ticket_price,total_seats,available_seats)
VALUES
('Tech Summit','2026-12-05',1,1,1200,500,350),
('Music Night','2026-12-12',2,2,800,1000,600),
('Data Workshop','2026-11-10',3,1,500,300,250),
('Startup Expo','2026-12-20',1,3,1500,500,200),
('Art Festival','2026-01-15',4,4,700,800,700),
('Career Fair','2026-10-28',3,2,300,300,280);

INSERT INTO Tickets
(event_id,attendee_id,booking_date,status)
VALUES
(1,1,'2026-10-18','Confirmed'),
(1,2,'2026-10-19','Confirmed'),
(2,1,'2026-10-20','Confirmed'),
(2,3,'2026-10-21','Pending'),
(3,4,'2026-10-22','Confirmed'),
(4,5,'2026-10-23','Pending'),
(1,6,'2026-10-23','Cancelled');

INSERT INTO Payments
(ticket_id,amount_paid,payment_status,payment_date)
VALUES
(1,1200,'Success','2026-10-18'),
(2,1200,'Success','2026-10-19'),
(3,800,'Success','2026-10-20'),
(4,800,'Pending','2026-10-21'),
(5,500,'Success','2026-10-22'),
(6,1500,'Failed','2026-10-23'),
(7,1200,'Refunded','2026-10-23');

-- 3. CRUD OPERATIONS (uncomment individually to practice)
-- CREATE: Add a new event
-- INSERT INTO Events (event_name,event_date,venue_id,organizer_id,ticket_price,total_seats,available_seats)
-- VALUES ('Gaming Fest','2026-12-25 12:00:00',2,3,600,400,400);

-- READ:
SELECT * FROM Events;

-- UPDATE example:
-- UPDATE Events SET ticket_price=1300 WHERE event_id=1;

-- DELETE example (delete only if no ticket references this event):
-- DELETE FROM Events WHERE event_id=6;

-- SEARCH example:
SELECT * FROM Events WHERE event_name LIKE '%Tech%';

-- 4. WHERE, HAVING, LIMIT
-- Upcoming events in a particular city
SELECT e.event_id,e.event_name,e.event_date,v.location
FROM Events e JOIN Venues v ON e.venue_id=v.venue_id 
WHERE e.event_date >= NOW() AND v.location='Surat'
ORDER BY e.event_date;

-- Top 5 events by successful revenue
SELECT e.event_name, SUM(p.amount_paid) AS revenue
FROM Events e
JOIN Tickets t ON e.event_id=t.event_id
JOIN Payments p ON t.ticket_id=p.ticket_id
WHERE p.payment_status='Success'
GROUP BY e.event_id,e.event_name
ORDER BY revenue DESC
LIMIT 5;

-- Attendees booking during the last 7 days
SELECT DISTINCT a.attendee_id,a.name,t.booking_date
FROM Attendees a JOIN Tickets t ON a.attendee_id=t.attendee_id
WHERE t.booking_date >= NOW() - INTERVAL 7 DAY;

-- HAVING: Events with more than one ticket record
SELECT e.event_name,COUNT(t.ticket_id) AS ticket_count
FROM Events e LEFT JOIN Tickets t ON e.event_id=t.event_id
GROUP BY e.event_id,e.event_name
HAVING COUNT(t.ticket_id)>1;

-- 5. AND, OR, NOT
-- Events in December with over 50% seats available
SELECT * FROM Events
WHERE MONTH(event_date)=12
  AND available_seats > total_seats * 0.50;

-- Attendees with a confirmed ticket OR a pending payment
SELECT DISTINCT a.attendee_id,a.name
FROM Attendees a
JOIN Tickets t ON a.attendee_id=t.attendee_id
LEFT JOIN Payments p ON t.ticket_id=p.ticket_id
WHERE t.status='Confirmed' OR p.payment_status='Pending';

-- Events that are not fully booked
SELECT * FROM Events WHERE NOT (available_seats=0);

-- 6. ORDER BY, GROUP BY
SELECT * FROM Events ORDER BY event_date ASC;

-- Count attendees/ticket bookings per event
SELECT e.event_name,COUNT(t.ticket_id) AS bookings
FROM Events e LEFT JOIN Tickets t ON e.event_id=t.event_id
GROUP BY e.event_id,e.event_name;

-- Successful revenue generated per event
SELECT e.event_name,
       COALESCE(SUM(CASE WHEN p.payment_status='Success' THEN p.amount_paid ELSE 0 END),0) AS revenue
FROM Events e
LEFT JOIN Tickets t ON e.event_id=t.event_id
LEFT JOIN Payments p ON t.ticket_id=p.ticket_id
GROUP BY e.event_id,e.event_name
ORDER BY revenue DESC;

-- 7. AGGREGATE FUNCTIONS
-- Total successful revenue
SELECT COALESCE(SUM(amount_paid),0) AS total_revenue
FROM Payments WHERE payment_status='Success';

-- Event with highest number of ticket records
SELECT e.event_name,COUNT(t.ticket_id) AS attendees
FROM Events e JOIN Tickets t ON e.event_id=t.event_id
GROUP BY e.event_id,e.event_name
ORDER BY attendees DESC LIMIT 1;

-- Average ticket price
SELECT AVG(ticket_price) AS average_ticket_price FROM Events;

-- MIN and MAX ticket price
SELECT MIN(ticket_price) AS minimum_price,MAX(ticket_price) AS maximum_price
FROM Events;

-- 8. KEY RELATIONSHIPS
-- Unique(event_id, attendee_id) prevents duplicate booking for the same event.
-- Payments.ticket_id references a valid Tickets row.

-- 9. JOINS
-- INNER JOIN: Event and venue details
SELECT e.event_name,e.event_date,v.venue_name,v.location
FROM Events e INNER JOIN Venues v ON e.venue_id=v.venue_id;

-- LEFT JOIN: Ticket holders with no successful payment
SELECT a.name,e.event_name,t.ticket_id,p.payment_status
FROM Tickets t
JOIN Attendees a ON t.attendee_id=a.attendee_id
JOIN Events e ON t.event_id=e.event_id
LEFT JOIN Payments p ON t.ticket_id=p.ticket_id AND p.payment_status='Success'
WHERE p.payment_id IS NULL AND t.status <> 'Cancelled';

-- RIGHT JOIN: Events with no ticket records (works in MySQL)
SELECT e.event_id,e.event_name
FROM Tickets t RIGHT JOIN Events e ON t.event_id=e.event_id
WHERE t.ticket_id IS NULL;

-- MySQL has no FULL OUTER JOIN; emulate attendees without bookings
SELECT a.attendee_id,a.name
FROM Attendees a LEFT JOIN Tickets t ON a.attendee_id=t.attendee_id
WHERE t.ticket_id IS NULL;

-- 10. SUBQUERIES
-- Events with successful revenue greater than average ticket price
SELECT e.event_id,e.event_name,SUM(p.amount_paid) AS revenue
FROM Events e
JOIN Tickets t ON e.event_id=t.event_id
JOIN Payments p ON t.ticket_id=p.ticket_id
WHERE p.payment_status='Success'
GROUP BY e.event_id,e.event_name
HAVING SUM(p.amount_paid) > (SELECT AVG(ticket_price) FROM Events);

-- Attendees who booked multiple events
SELECT a.attendee_id,a.name,COUNT(DISTINCT t.event_id) AS events_booked
FROM Attendees a JOIN Tickets t ON a.attendee_id=t.attendee_id
GROUP BY a.attendee_id,a.name
HAVING COUNT(DISTINCT t.event_id)>1;

-- Organizers who manage at least 2 events (corrected to avoid an empty result with sample data)
SELECT o.organizer_id,o.organizer_name,COUNT(e.event_id) AS event_count
FROM Organizers o JOIN Events e ON o.organizer_id=e.organizer_id
GROUP BY o.organizer_id,o.organizer_name
HAVING COUNT(e.event_id)>=2
ORDER BY event_count DESC;

-- 11. DATE & TIME FUNCTIONS
-- Extract month from event date
SELECT event_name,MONTH(event_date) AS event_month FROM Events;

-- Days remaining until each upcoming event
SELECT event_name,event_date,DATEDIFF(event_date,CURDATE()) AS days_remaining
FROM Events WHERE event_date >= NOW();

-- Format payment date
SELECT payment_id,DATE_FORMAT(payment_date,'%Y-%m-%d') AS formatted_payment_date
FROM Payments;

-- 12. STRING FUNCTIONS
-- Organizer names in uppercase
SELECT UPPER(organizer_name) AS organizer_name_upper FROM Organizers;

-- Trim extra spaces from attendee names (TRIM removes outer spaces)
SELECT attendee_id,TRIM(name) AS clean_name FROM Attendees;

-- Replace NULL email values with Not Provided
SELECT attendee_id,name,COALESCE(email,'Not Provided') AS email
FROM Attendees;

-- 13. QUICK TABLE CHECKS
SELECT * FROM Venues;
SELECT * FROM Organizers;
SELECT * FROM Attendees;
SELECT * FROM Tickets;
SELECT * FROM Payments;
