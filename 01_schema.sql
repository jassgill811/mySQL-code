CREATE DATABASE IF NOT EXISTS crownfield_eye_hospital;
USE crownfield_eye_hospital;


CREATE TABLE Patient (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    postcode VARCHAR(10) NOT NULL,
    date_of_birth DATE NULL,
    contact_number VARCHAR(20),
    email VARCHAR(100) UNIQUE
);

CREATE TABLE Specialty (
    specialty_id INT AUTO_INCREMENT PRIMARY KEY,
    specialty_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Clinician (
    clinician_id INT AUTO_INCREMENT PRIMARY KEY,
    specialty_id INT NOT NULL,
    clinician_name VARCHAR(100) NOT NULL,
    staff_role VARCHAR(50) NOT NULL,
    FOREIGN KEY (specialty_id)
        REFERENCES Specialty(specialty_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

CREATE TABLE Clinic (
    clinic_id INT AUTO_INCREMENT PRIMARY KEY,
    clinic_name VARCHAR(100) NOT NULL,
    location VARCHAR(150) NOT NULL,
    UNIQUE (clinic_name, location)
);

CREATE TABLE Appointment (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    clinician_id INT NOT NULL,
    clinic_id INT NOT NULL,
    appointment_datetime DATETIME NOT NULL,
    appointment_status VARCHAR(20) NOT NULL DEFAULT 'Scheduled',
    notes TEXT,
    FOREIGN KEY (patient_id)
        REFERENCES Patient(patient_id)
        ON DELETE RESTRICT,
    FOREIGN KEY (clinician_id)
        REFERENCES Clinician(clinician_id)
        ON DELETE RESTRICT,
    FOREIGN KEY (clinic_id)
        REFERENCES Clinic(clinic_id)
        ON DELETE RESTRICT,
    CHECK (appointment_status IN (
        'Scheduled', 'Completed',
        'Cancelled', 'Did Not Attend'
    ))
);

CREATE TABLE Diagnosis (
    diagnosis_id INT AUTO_INCREMENT PRIMARY KEY,
    diagnosis_code VARCHAR(30) UNIQUE,
    diagnosis_name VARCHAR(150) NOT NULL
);

CREATE TABLE AppointmentDiagnosis (
    appointment_id INT NOT NULL,
    diagnosis_id INT NOT NULL,
    diagnosis_notes TEXT,
    PRIMARY KEY (appointment_id, diagnosis_id),
    FOREIGN KEY (appointment_id)
        REFERENCES Appointment(appointment_id)
        ON DELETE CASCADE,
    FOREIGN KEY (diagnosis_id)
        REFERENCES Diagnosis(diagnosis_id)
        ON DELETE RESTRICT
);

CREATE TABLE Prescription (
    prescription_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT NOT NULL,
    prescription_date DATE NOT NULL,
    FOREIGN KEY (appointment_id)
        REFERENCES Appointment(appointment_id)
        ON DELETE RESTRICT
);

CREATE TABLE Medicine (
    medicine_id INT AUTO_INCREMENT PRIMARY KEY,
    medicine_name VARCHAR(150) NOT NULL,
    medicine_form VARCHAR(50),
    UNIQUE (medicine_name, medicine_form)
);

CREATE TABLE PrescriptionItem (
    prescription_item_id INT AUTO_INCREMENT PRIMARY KEY,
    prescription_id INT NOT NULL,
    medicine_id INT NOT NULL,
    dose VARCHAR(100) NOT NULL,
    route VARCHAR(50) NOT NULL,
    frequency VARCHAR(100) NOT NULL,
    duration_days INT NOT NULL,
    FOREIGN KEY (prescription_id)
        REFERENCES Prescription(prescription_id)
        ON DELETE CASCADE,
    FOREIGN KEY (medicine_id)
        REFERENCES Medicine(medicine_id)
        ON DELETE RESTRICT,
    CHECK (duration_days > 0)
);

CREATE TABLE FollowUpPlan (
    follow_up_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT NOT NULL,
    due_date DATE NOT NULL,
    priority VARCHAR(20) NOT NULL DEFAULT 'Routine',
    follow_up_status VARCHAR(20) NOT NULL DEFAULT 'Pending',
    FOREIGN KEY (appointment_id)
        REFERENCES Appointment(appointment_id)
        ON DELETE RESTRICT,
    CHECK (priority IN (
        'Low', 'Routine', 'High', 'Urgent'
    )),
    CHECK (follow_up_status IN (
        'Pending', 'Scheduled', 'Completed', 'Cancelled'
    ))
);

USE crownfield_eye_hospital;

-- 1. SPECIALTY: 10 records
INSERT INTO Specialty (specialty_id, specialty_name) VALUES
(1,'Glaucoma'),
(2,'Retina'),
(3,'Cataract'),
(4,'Cornea'),
(5,'Paediatric Ophthalmology'),
(6,'Oculoplastics'),
(7,'Neuro-Ophthalmology'),
(8,'Medical Retina'),
(9,'Uveitis'),
(10,'General Ophthalmology');

-- 2. CLINICIAN: 10 records
INSERT INTO Clinician
(clinician_id, specialty_id, clinician_name, staff_role) VALUES
(1,1,'Dr Maya Shah','Consultant Ophthalmologist'),
(2,2,'Dr Leo Grant','Consultant Ophthalmologist'),
(3,3,'Dr Priya Nair','Consultant Ophthalmologist'),
(4,4,'Dr Oliver Reed','Specialty Doctor'),
(5,5,'Dr Sarah Ahmed','Consultant Ophthalmologist'),
(6,6,'Dr James Wilson','Specialty Doctor'),
(7,7,'Dr Emily Brown','Consultant Ophthalmologist'),
(8,8,'Dr Noah Williams','Consultant Ophthalmologist'),
(9,9,'Dr Aisha Khan','Specialty Doctor'),
(10,10,'Dr Daniel Clarke','Clinical Fellow');

-- 3. CLINIC: 10 records
INSERT INTO Clinic (clinic_id, clinic_name, location) VALUES
(1,'Glaucoma Clinic','City Road'),
(2,'Retina Clinic','City Road'),
(3,'Cataract Clinic','Bedford'),
(4,'Cornea Clinic','Croydon'),
(5,'Paediatric Eye Clinic','Luton'),
(6,'Oculoplastics Clinic','London'),
(7,'Neuro-Ophthalmology Clinic','Manchester'),
(8,'Medical Retina Clinic','Birmingham'),
(9,'Uveitis Clinic','Leeds'),
(10,'General Eye Clinic','Bristol');

-- 4. PATIENT: 12 records
-- First four patients reflect the distinct patients in Appendix 1.
INSERT INTO Patient
(patient_id, first_name, last_name, postcode, date_of_birth,
 contact_number, email) VALUES
(1,'Amina','Yusuf','NE1 4AB','1972-04-11',
 '07000000001','amina.yusuf@example.test'),
(2,'Daniel','Reed','N16 7QP','1965-09-22',
 '07000000002','daniel.reed@example.test'),
(3,'Sofia','Bennett','E8 2LD','1988-01-14',
 '07000000003','sofia.bennett@example.test'),
(4,'Michael','Okoro','SE6 3RT','1977-06-30',
 '07000000004','michael.okoro@example.test'),
(5,'Emma','Wilson','LU1 2AB','1990-02-18',
 '07000000005','emma.wilson@example.test'),
(6,'Oliver','Taylor','MK1 1CD','1958-11-09',
 '07000000006','oliver.taylor@example.test'),
(7,'Isabella','Thomas','CB2 3EF','2005-07-21',
 '07000000007','isabella.thomas@example.test'),
(8,'Noah','Roberts','OX1 4GH','1983-03-15',
 '07000000008','noah.roberts@example.test'),
(9,'Amelia','Johnson','LS1 5JK','1970-12-05',
 '07000000009','amelia.johnson@example.test'),
(10,'Ethan','Brown','B1 6LM','1998-09-26',
 '07000000010','ethan.brown@example.test'),
(11,'Grace','Davies','CF10 1NP','1949-05-12',
 '07000000011','grace.davies@example.test'),
(12,'Arjun','Patel','NG1 7QR','1986-08-03',
 '07000000012','arjun.patel@example.test');

-- 5. DIAGNOSIS: 10 records
INSERT INTO Diagnosis
(diagnosis_id, diagnosis_code, diagnosis_name) VALUES
(1,'DX001','Ocular hypertension'),
(2,'DX002','Diabetic macular oedema'),
(3,'DX003','Glaucoma suspect'),
(4,'DX004','Keratoconus'),
(5,'DX005','Age-related cataract'),
(6,'DX006','Dry eye disease'),
(7,'DX007','Retinal vein occlusion'),
(8,'DX008','Amblyopia'),
(9,'DX009','Anterior uveitis'),
(10,'DX010','Refractive error');

-- 6. MEDICINE: 10 records
INSERT INTO Medicine
(medicine_id, medicine_name, medicine_form) VALUES
(1,'Latanoprost','Eye drops'),
(2,'Aflibercept','Injection'),
(3,'Sodium chloride','Eye drops'),
(4,'Timolol','Eye drops'),
(5,'Artificial tears','Eye drops'),
(6,'Prednisolone acetate','Eye drops'),
(7,'Dorzolamide','Eye drops'),
(8,'Brimonidine','Eye drops'),
(9,'Moxifloxacin','Eye drops'),
(10,'Cyclopentolate','Eye drops');

-- 7. APPOINTMENT: 15 records
-- Appointments 1-5 represent the five Appendix 1 rows.
-- Appointment 3 is a second visit by patient 1.
INSERT INTO Appointment
(appointment_id, patient_id, clinician_id, clinic_id,
 appointment_datetime, appointment_status, notes) VALUES
(1,1,1,1,'2026-10-05 09:00:00','Completed','Review IOP'),
(2,2,2,2,'2026-10-05 09:30:00','Completed','OCT before review'),
(3,1,1,3,'2026-11-16 10:15:00','Scheduled','Visual field test'),
(4,3,1,1,'2026-10-06 11:00:00','Completed','Monitor glaucoma suspect'),
(5,4,3,4,'2026-10-07 14:00:00','Completed','Corneal topography'),
(6,5,3,3,'2026-10-12 09:00:00','Scheduled','Cataract assessment'),
(7,6,4,4,'2026-10-13 10:00:00','Scheduled','Corneal examination'),
(8,7,5,5,'2026-10-14 11:00:00','Scheduled','Child vision review'),
(9,8,6,6,'2026-10-15 12:00:00','Scheduled','Eyelid assessment'),
(10,9,7,7,'2026-10-16 13:00:00','Scheduled','Visual symptoms review'),
(11,10,8,8,'2026-10-17 14:00:00','Scheduled','Retinal review'),
(12,11,9,9,'2026-10-18 09:30:00','Cancelled','Appointment cancelled'),
(13,12,10,10,'2026-10-19 10:30:00','Scheduled','Routine eye examination'),
(14,5,1,1,'2026-10-20 11:30:00','Scheduled','Pressure monitoring'),
(15,2,2,2,'2026-10-21 12:00:00','Scheduled','Macular follow-up');

-- 8. APPOINTMENTDIAGNOSIS: 15 linked records
INSERT INTO AppointmentDiagnosis
(appointment_id, diagnosis_id, diagnosis_notes) VALUES
(1,1,'Ocular hypertension reviewed'),
(2,2,'Diabetic macular oedema assessed'),
(3,1,'Repeat pressure assessment planned'),
(4,3,'Glaucoma suspect monitoring'),
(5,4,'Corneal shape assessment'),
(6,5,'Cataract assessment'),
(7,6,'Dry eye symptoms reviewed'),
(8,8,'Visual development review'),
(9,6,'Ocular surface assessment'),
(10,7,'Retinal circulation assessment'),
(11,2,'Macular monitoring'),
(12,9,'Uveitis review postponed'),
(13,10,'Refraction assessment'),
(14,1,'Pressure monitoring'),
(15,2,'Retinal follow-up');

-- 9. PRESCRIPTION: 10 records
INSERT INTO Prescription
(prescription_id, appointment_id, prescription_date) VALUES
(1,1,'2026-10-05'),
(2,2,'2026-10-05'),
(3,3,'2026-11-16'),
(4,4,'2026-10-06'),
(5,5,'2026-10-07'),
(6,7,'2026-10-13'),
(7,9,'2026-10-15'),
(8,10,'2026-10-16'),
(9,11,'2026-10-17'),
(10,15,'2026-10-21');

-- 10. PRESCRIPTIONITEM: 12 medicine items
INSERT INTO PrescriptionItem
(prescription_item_id, prescription_id, medicine_id,
 dose, route, frequency, duration_days) VALUES
(1,1,1,'1 drop','Ophthalmic','Once daily',30),
(2,1,4,'1 drop','Ophthalmic','Twice daily',30),
(3,2,2,'As prescribed by clinician','Intravitreal','As scheduled by specialist',30),
(4,3,1,'1 drop','Ophthalmic','Once daily',30),
(5,4,4,'1 drop','Ophthalmic','Twice daily',30),
(6,5,3,'As prescribed','Ophthalmic','As directed',14),
(7,6,5,'1-2 drops','Ophthalmic','As required',30),
(8,7,6,'1 drop','Ophthalmic','As directed by clinician',7),
(9,8,7,'1 drop','Ophthalmic','Three times daily',30),
(10,9,8,'1 drop','Ophthalmic','Twice daily',30),
(11,10,2,'As prescribed by clinician','Intravitreal','As scheduled by specialist',30),
(12,10,5,'1-2 drops','Ophthalmic','As required',30);

-- 11. FOLLOWUPPLAN: 12 records
INSERT INTO FollowUpPlan
(follow_up_id, appointment_id, due_date, priority,
 follow_up_status) VALUES
(1,1,'2026-11-16','High','Pending'),
(2,2,'2026-11-02','Urgent','Scheduled'),
(3,3,'2027-02-08','Routine','Pending'),
(4,4,'2026-12-06','Routine','Pending'),
(5,5,'2026-12-02','Routine','Pending'),
(6,6,'2026-11-12','High','Scheduled'),
(7,7,'2026-11-13','Routine','Pending'),
(8,8,'2026-11-14','Routine','Pending'),
(9,9,'2026-12-15','Low','Pending'),
(10,10,'2026-11-16','High','Scheduled'),
(11,11,'2026-11-17','Urgent','Pending'),
(12,15,'2026-11-21','High','Pending');


START TRANSACTION;
UPDATE Appointment
SET appointment_status = 'Scheduled',
    notes = 'Appointment rescheduled for review'
WHERE appointment_id = 5
  AND appointment_status = 'Completed';
-- Verify the change
SELECT appointment_id, appointment_status, notes
FROM Appointment
WHERE appointment_id = 5;
COMMIT;

START TRANSACTION;
-- Check the record before deletion
SELECT follow_up_id, appointment_id, due_date
FROM FollowUpPlan
WHERE follow_up_id = 12;
-- Delete only the selected follow-up plan
DELETE FROM FollowUpPlan
WHERE follow_up_id = 12
  AND appointment_id = 15;
-- Verify the deletion
SELECT *
FROM FollowUpPlan
WHERE follow_up_id = 12;
COMMIT;
