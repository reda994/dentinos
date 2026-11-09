# 🦷 DENTINO — Dental Clinic Management System

<p align="center">
  <strong>Smart Management for Modern Dental Clinics</strong>
</p>

<p align="center">
  A desktop application designed to simplify and centralize dental clinic management.
</p>

---

## 📌 About the Project

**DENTINO** is a desktop application for managing the daily activities of a dental clinic.

The application aims to centralize administrative, medical, and financial operations in one system, providing a simple, organized, and efficient working environment for dentists and clinic staff.

This project is developed as part of a university engineering project by a team of six developers.

## 🎯 Project Objectives

- Centralize patient information and medical records.
- Manage appointments and dental consultations.
- Organize prescriptions and dental treatments.
- Manage invoices, payments, and patient credits.
- Provide statistics and a dashboard.
- Improve the organization and efficiency of dental clinic operations.

## ✨ Main Features

| Module | Description |
|---|---|
| 🔐 Authentication | User login and role-based access |
| 👥 Patients | Create, update, search, and manage patients |
| 📁 Medical Records | Manage patient medical histories and antecedents |
| 📅 Appointments | Schedule and manage appointments |
| 🩺 Consultations | Record consultations and dental treatments |
| 💊 Prescriptions | Manage prescriptions and medications |
| 🧾 Invoices | Create and manage invoices |
| 💳 Payments | Track payments, balances, and patient credits |
| 📊 Dashboard | Display important clinic statistics |
| 👤 Users | Manage application users and permissions |

## 🛠️ Technologies

The project uses the following technologies:

| Technology | Purpose |
|---|---|
| Java 17+ | Main programming language |
| Java Swing | Desktop graphical interface |
| Maven | Project and dependency management |
| JDBC | Database connectivity |
| MySQL 8.0+ | Relational database |
| Lombok | Reduce repetitive Java code |
| JUnit | Unit testing |
| Git & GitHub | Version control and collaboration |

**Important:** JavaFX, Spring, Spring Boot, Hibernate, JPA, and other ORM frameworks are not used in this project.

## 🏗️ Architecture

DENTINO follows a **three-tier architecture combined with MVC**.

```text
┌───────────────────────────────┐
│          PRESENTATION         │
│                               │
│       Java Swing Views        │
│       Controllers             │
└───────────────┬───────────────┘
                │
                ▼
┌───────────────────────────────┐
│          BUSINESS             │
│                               │
│       Services                │
│       Business Rules          │
│       Validation              │
└───────────────┬───────────────┘
                │
                ▼
┌───────────────────────────────┐
│           DATA                │
│                               │
│       Repositories            │
│       JDBC                    │
│       MySQL                   │
└───────────────────────────────┘
```

### Application Flow

`View → Controller → Service → Repository → MySQL`

Each layer has a specific responsibility:

- **View:** Displays the graphical interface.
- **Controller:** Handles user interactions.
- **Service:** Implements business logic and validation.
- **Repository:** Handles database operations using JDBC.
- **Domain:** Contains business entities.
- **DTO:** Transfers data between application layers.

## 📂 Project Structure

```text
DENTINO/
│
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── ma/
│   │   │       └── dentinos/
│   │   │           ├── DentinosApp.java
│   │   │           │
│   │   │           ├── config/
│   │   │           ├── domain/
│   │   │           ├── dto/
│   │   │           ├── exceptions/
│   │   │           │
│   │   │           ├── repository/
│   │   │           │   ├── api/
│   │   │           │   └── jdbcMySql/
│   │   │           │
│   │   │           ├── service/
│   │   │           │   ├── api/
│   │   │           │   └── impl/
│   │   │           │
│   │   │           ├── ui/
│   │   │           │   ├── controllers/
│   │   │           │   ├── model/
│   │   │           │   ├── components/
│   │   │           │   ├── view/
│   │   │           │   └── theme/
│   │   │           │
│   │   │           └── utils/
│   │   │
│   │   └── resources/
│   │       ├── images/
│   │       ├── icons/
│   │       └── application.properties.example
│   │
│   └── test/
│       └── java/
│
├── database/
│   ├── schema.sql
│   └── data.sql
│
├── docs/
│   ├── uml/
│   ├── screenshots/
│   └── documentation/
│
├── pom.xml
├── .gitignore
└── README.md
```

*The structure may evolve during development while preserving the agreed architecture.*

## ⚙️ Installation and Setup

### 1. Prerequisites

Make sure you have installed:

- JDK 17 or higher.
- Apache Maven.
- MySQL Server 8.0 or higher.
- IntelliJ IDEA, Eclipse, or another Java IDE.
- Git.

Verify your Java and Maven installations:

```bash
java -version
mvn -version
```

### 2. Clone the Repository

```bash
git clone https://github.com/reda994/dentinos.git
```

```bash
cd DENTINO
```

Replace `https://github.com/reda994/dentinos.git` with the actual repository URL.

### 3. Create the Database

Start MySQL and execute:

```sql
CREATE DATABASE dentino_db
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;
```

Import the database schema:

```bash
mysql -u root -p dentino_db < database/schema.sql
```

If demonstration data is available:

```bash
mysql -u root -p dentino_db < database/data.sql
```

### 4. Configure Database Connection

Configure the database connection using the project's configuration mechanism.

Example configuration:

```properties
db.url=jdbc:mysql://localhost:3306/dentino_db
db.username=root
db.password=YOUR_PASSWORD
```

Use your actual MySQL credentials.

Do not commit real passwords or sensitive credentials to GitHub.

### 5. Build the Project

```bash
mvn clean install
```

### 6. Run the Application

Run the main class:

```text
ma.dentalSoft.DentalSoftApp
```

You can also run it directly from your Java IDE.

## 🧪 Testing

Run the project's tests using:

```bash
mvn test
```

Tests should cover:

- Database connectivity.
- Authentication.
- Patient management.
- Appointment management.
- Invoice calculations.
- Payment management.
- Business validation.

## 👥 Development Team

DENTINO is developed collaboratively by a team of six members.

| Member | Responsibility |
|---|---|
| Developer 1 | Technical architecture and project foundation |
| Developer 2 | Authentication and user management |
| Developer 3 | Patient and medical records management |
| Developer 4 | Appointments and scheduling |
| Developer 5 | Invoices, payments, and credits |
| Developer 6 | Dashboard, statistics, and integration tests |

*Replace these roles with the actual team members' names.*

## 🌿 Git Workflow

The project uses Git for collaborative development.

Main branches:

```text
main
└── develop
    ├── feature/socle-technique
    ├── feature/authentification
    ├── feature/patients
    ├── feature/agenda
    ├── feature/finance
    └── feature/statistiques
```

### Contribution Rules

1. Create your feature branch from `develop`.
2. Work only on your assigned module.
3. Follow the approved architecture.
4. Commit your changes with meaningful messages.
5. Push your branch to GitHub.
6. Open a Pull Request targeting `develop`.
7. Review and test changes before merging.

Example:

```bash
git checkout develop
git pull origin develop
git checkout -b feature/patients
```

Commit and push:

```bash
git add .
git commit -m "feat: implement patient management"
git push origin feature/patients
```

## 🔒 Development Standards

All developers must respect these rules:

- Follow the agreed package structure.
- Keep SQL queries inside Repository classes.
- Use `PreparedStatement` for database queries.
- Use `try-with-resources` for JDBC resources.
- Map `ResultSet` rows explicitly to Java objects.
- Keep business logic inside Service classes.
- Keep Swing views separate from business logic.
- Avoid duplicated classes and methods.
- Do not modify shared architecture files without team approval.
- Do not commit passwords or database credentials.

## 🚀 Future Improvements

Potential future improvements include:

- Advanced appointment notifications.
- More detailed financial reports.
- PDF invoice generation.
- Database backup and restoration.
- Advanced statistics.
- Improved user permissions.
- Application deployment and packaging.

## 📄 Project Status

**Development in progress.**

Features and documentation are subject to change as the project evolves.

## 📜 License

This project is developed for educational purposes as part of a university engineering project.

---

<p align="center">
  <strong>DENTINO — Simplifying Dental Clinic Management 🦷</strong>
</p>
