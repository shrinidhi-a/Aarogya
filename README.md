# 🏥 Hospital Management System (ColdFusion)

A web-based **Hospital Management System** built using **Adobe ColdFusion** that streamlines patient registration, appointment scheduling, doctor availability, and admin management.

## 📌 Overview

This project is designed to automate and manage hospital activities such as:

- Patient Registration & Login
- Appointment Booking
- Doctor Availability Scheduling
- Admin Panel for Managing Doctors and Appointments
- Session Management and Basic Authentication

Built with the **FW/1 (Framework One)** ColdFusion MVC framework for clean separation of concerns and easier maintenance.

---

## 🛠️ Technologies Used

- **Backend**: Adobe ColdFusion (CFML)
- **Framework**: FW/1 (Framework One)
- **Frontend**: HTML, CSS, Bootstrap, JavaScript, jQuery
- **Database**: Microsoft SQL Server (or MySQL/PostgreSQL, as applicable)

---

## 🗂️ Project Structure

```
Hospital-Management-System/
│
├── controllers/             # CFCs for handling business logic
├── model/                   # Data access layer (DAO/Service)
├── views/                   # CFML views (HTML with embedded CFML)
├── framework/               # FW/1 framework files
├── Application.cfc          # Application settings
├── index.cfm                # Main entry point
└── README.md
```

---

## 💻 Features

### 👩‍⚕️ Patients
- Register/Login
- Book appointments with available doctors
- View appointment history

### 🧑‍⚕️ Doctors
- View schedule
- Manage availability (admin-side feature)

### 🔑 Admin
- Add/Edit/Delete doctor profiles
- Set doctor availability slots
- View and manage all appointments
- Search/filter patients or appointments

---

## 🚀 Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/your-username/hospital-management-coldfusion.git
cd hospital-management-coldfusion
```

### 2. Setup ColdFusion Server

- Use **Adobe ColdFusion** or **Lucee** server.
- Deploy project directory in your ColdFusion webroot.
- Set up a datasource in ColdFusion Admin Panel (e.g., `hospital_db`).

### 3. Configure Database Connection

Update your `Application.cfc` or any DB config file with your database credentials and datasource name:

```cfml
<cfset application.datasource = "hospital_db">
```

### 4. Run the App

Access it via your browser:

```
http://localhost:8500/hospital-management-coldfusion
```

---

## 🧾 Sample Credentials

```txt
Admin Login:
Username: admin
Password: admin123

Test Patient:
Username: testuser
Password: test123
```

---

## 📌 Future Improvements

- Role-based access for doctors
- Email/SMS notifications for appointments
- Responsive design for mobile access
- Integration with calendar (Google Calendar, Outlook, etc.)

---

## 📃 License

This project is open-source and available under the [MIT License](LICENSE).

---

## 🙋‍♂️ Author

**Shrinidhi A**  
🔗 [GitHub Profile](https://github.com/shrinidhi-a)
