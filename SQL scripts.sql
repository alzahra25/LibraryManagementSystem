CREATE DATABASE LibraryMS;
USE LibraryMS;

--DDL ----

-- Create Library Table
CREATE TABLE Library (
    LibraryID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Location VARCHAR(100),
    ContactNumber VARCHAR(20),
    EstablishedYear INT
);

-- Create Book Table
CREATE TABLE Book (
    BookID INT PRIMARY KEY,
    LibraryID INT,
    ISBN VARCHAR(20) UNIQUE NOT NULL,
    Title VARCHAR(150) NOT NULL,
    Genre VARCHAR(50) CHECK (Genre IN ('Fiction', 'Non-fiction', 'Reference', 'Children')),
    Price DECIMAL(6,2) CHECK (Price > 0),
	IsAvailable BIT DEFAULT 1,
    ShelfLocation VARCHAR(50),
    FOREIGN KEY (LibraryID) REFERENCES Library(LibraryID) ON DELETE CASCADE
);

-- Create Member Table
CREATE TABLE Member (
    MemberID INT PRIMARY KEY,
    FullName VARCHAR(100),
    Email VARCHAR(100) UNIQUE,
    PhoneNumber VARCHAR(20),
    MembershipStartDate DATE
);

-- Create Staff Table
CREATE TABLE Staff (
    StaffID INT PRIMARY KEY,
    LibraryID INT,
    FullName VARCHAR(100),
    Position VARCHAR(50),
    ContactNumber VARCHAR(20),
    FOREIGN KEY (LibraryID) REFERENCES Library(LibraryID) ON DELETE CASCADE
);

-- Create Loan Table
CREATE TABLE Loan (
    LoanID INT PRIMARY KEY,
    MemberID INT,
    BookID INT,
    LoanDate DATE,
    DueDate DATE,
    ReturnDate DATE,
    Status VARCHAR(20) DEFAULT 'Issued'
        CHECK (Status IN ('Issued', 'Returned', 'Overdue')),
    FOREIGN KEY (MemberID) REFERENCES Member(MemberID) ON DELETE CASCADE,
    FOREIGN KEY (BookID) REFERENCES Book(BookID) ON DELETE CASCADE
);

-- Create Payment Table
CREATE TABLE Payment (
    PaymentID INT PRIMARY KEY,
    LoanID INT,
    PaymentDate DATE,
    Amount DECIMAL(6,2) CHECK (Amount > 0),
    Method VARCHAR(50) NOT NULL,
    FOREIGN KEY (LoanID) REFERENCES Loan(LoanID) ON DELETE CASCADE
);

-- Create Review Table
CREATE TABLE Review (
    ReviewID INT PRIMARY KEY,
    MemberID INT,
    BookID INT,
    Rating INT CHECK (Rating BETWEEN 1 AND 5),
    Comments TEXT DEFAULT 'No comments',
    ReviewDate DATE,
    FOREIGN KEY (MemberID) REFERENCES Member(MemberID) ON DELETE CASCADE,
    FOREIGN KEY (BookID) REFERENCES Book(BookID) ON DELETE CASCADE
);


--DML --

-- Insert Libraries
INSERT INTO Library (LibraryID, Name, Location, ContactNumber, EstablishedYear) VALUES (1, 'Central Library', 'Downtown', '99887766', 1995);
INSERT INTO Library (LibraryID, Name, Location, ContactNumber, EstablishedYear) VALUES (2, 'Westside Library', 'Al Khuwair', '99776655', 2001);
INSERT INTO Library (LibraryID, Name, Location, ContactNumber, EstablishedYear) VALUES (3, 'Tech Library', 'Ruwi', '99665544', 2010);


-- Insert Books
INSERT INTO Book (BookID, LibraryID, ISBN, Title, Genre, Price, IsAvailable, ShelfLocation) VALUES
(1, 1, '9780140449136', 'The Odyssey', 'Fiction', 10.5, 1, 'A12'),
(2, 1, '9780451524935', '1984', 'Fiction', 9.75, 1, 'B22'),
(3, 1, '9780262033848', 'Introduction to Algorithms', 'Reference', 120.0, 1, 'C33'),
(4, 2, '9780590353427', 'Harry Potter', 'Children', 8.99, 0, 'D44'),
(5, 2, '9780307277671', 'Guns, Germs, and Steel', 'Non-fiction', 14.99, 1, 'E11'),
(6, 2, '9780131103627', 'C Programming', 'Reference', 39.99, 1, 'F12'),
(7, 3, '9780061120084', 'To Kill a Mockingbird', 'Fiction', 12.5, 0, 'G21'),
(8, 3, '9780201616224', 'The Pragmatic Programmer', 'Reference', 33.33, 1, 'H31'),
(9, 3, '9781491957660', 'Fluent Python', 'Reference', 45.00, 1, 'I19'),
(10, 3, '9780132350884', 'Clean Code', 'Reference', 40.00, 1, 'J25');


-- Insert Members
INSERT INTO Member (MemberID, FullName, Email, PhoneNumber, MembershipStartDate) VALUES
(1, 'Ahmed Al-Farsi', 'ahmed@example.com', '91234567', '2020-01-10'),
(2, 'Fatma Al-Mazroui', 'fatma@example.com', '92345678', '2021-03-15'),
(3, 'Salim Al-Harthy', 'salim@example.com', '93456789', '2019-05-20'),
(4, 'Mona Al-Zadjali', 'mona@example.com', '94567890', '2022-06-01'),
(5, 'Ali Al-Sinani', 'ali@example.com', '95678901', '2021-09-12'),
(6, 'Huda Al-Shukaili', 'huda@example.com', '96789012', '2020-12-25');

-- Insert Staff
INSERT INTO Staff (StaffID, LibraryID, FullName, Position, ContactNumber) VALUES
(1, 1, 'Zahra Al-Abri', 'Librarian', '91112233'),
(2, 1, 'Khalid Al-Busaidi', 'Assistant', '92223344'),
(3, 2, 'Raya Al-Hinai', 'Librarian', '93334455'),
(4, 3, 'Hassan Al-Nabhani', 'Librarian', '94445566');

-- Insert Loans
INSERT INTO Loan (LoanID, MemberID, BookID, LoanDate, DueDate, ReturnDate, Status) VALUES
(1, 1, 1, '2024-05-01', '2024-05-15', '2024-05-14', 'Returned'),
(2, 1, 2, '2024-05-16', '2024-05-30', NULL, 'Issued'),
(3, 2, 4, '2024-05-10', '2024-05-24', NULL, 'Overdue'),
(4, 3, 5, '2024-04-20', '2024-05-04', '2024-05-02', 'Returned'),
(5, 4, 6, '2024-05-05', '2024-05-19', NULL, 'Issued'),
(6, 5, 7, '2024-05-02', '2024-05-16', NULL, 'Overdue'),
(7, 6, 8, '2024-05-12', '2024-05-26', NULL, 'Issued'),
(8, 3, 9, '2024-05-14', '2024-05-28', NULL, 'Issued'),
(9, 4, 10, '2024-05-18', '2024-06-01', NULL, 'Issued'),
(10, 2, 3, '2024-05-22', '2024-06-05', NULL, 'Issued');


-- Insert Payments
INSERT INTO Payment (PaymentID, LoanID, PaymentDate, Amount, Method) VALUES
(1, 1, '2024-05-16', 2.0, 'Cash'),
(2, 3, '2024-05-25', 5.0, 'Card'),
(3, 4, '2024-05-05', 1.5, 'Cash'),
(4, 6, '2024-05-18', 3.0, 'Online');


-- Insert Reviews
INSERT INTO Review (ReviewID, MemberID, BookID, Rating, Comments, ReviewDate) VALUES
(1, 1, 1, 5, 'A great classic!', '2024-05-02'),
(2, 2, 4, 4, 'My kids loved it', '2024-05-12'),
(3, 3, 5, 3, 'Good content', '2024-05-15'),
(4, 4, 6, 5, 'Very helpful for exams', '2024-05-06'),
(5, 5, 7, 2, 'Not what I expected', '2024-05-10'),
(6, 6, 8, 4, 'Nice for programmers', '2024-05-20');

--DQL --

-- GET /loans/overdue
SELECT m.FullName, b.Title, l.DueDate
FROM Loan l
JOIN Member m ON l.MemberID = m.MemberID
JOIN Book b ON l.BookID = b.BookID
WHERE l.Status = 'Overdue';

-- GET /books/unavailable
SELECT Title, ISBN FROM Book WHERE IsAvailable = 0;

-- GET /members/top-borrowers
SELECT m.FullName, COUNT(*) AS BorrowedCount
FROM Loan l
JOIN Member m ON l.MemberID = m.MemberID
GROUP BY m.FullName
HAVING COUNT(*) > 2;

-- GET /books/:id/ratings
SELECT BookID, AVG(Rating) AS AverageRating
FROM Review
GROUP BY BookID;

-- GET /libraries/:id/genres
SELECT LibraryID, Genre, COUNT(*) AS GenreCount
FROM Book
GROUP BY LibraryID, Genre;

-- GET /members/inactive
SELECT m.FullName
FROM Member m
LEFT JOIN Loan l ON m.MemberID = l.MemberID
WHERE l.LoanID IS NULL;

-- GET /payments/summary
SELECT m.FullName, SUM(p.Amount) AS TotalPaid
FROM Payment p
JOIN Loan l ON p.LoanID = l.LoanID
JOIN Member m ON l.MemberID = m.MemberID
GROUP BY m.FullName;

-- GET /reviews
SELECT r.ReviewID, m.FullName, b.Title, r.Rating, r.Comments
FROM Review r
JOIN Member m ON r.MemberID = m.MemberID
JOIN Book b ON r.BookID = b.BookID;
