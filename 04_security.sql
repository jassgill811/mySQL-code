-- Create roles
CREATE ROLE IF NOT EXISTS 'hospital_admin';
CREATE ROLE IF NOT EXISTS 'doctor_role';
CREATE ROLE IF NOT EXISTS 'receptionist_role';
CREATE ROLE IF NOT EXISTS 'patient_role';

-- ADMINISTRATOR: full permissions
GRANT SELECT, INSERT, UPDATE, DELETE
ON crownfield_eye_hospital.*
TO 'hospital_admin';

-- DOCTOR: view clinical and patient information
GRANT SELECT
ON crownfield_eye_hospital.Patient
TO 'doctor_role';

GRANT SELECT, INSERT, UPDATE
ON crownfield_eye_hospital.AppointmentDiagnosis
TO 'doctor_role';

GRANT SELECT, INSERT, UPDATE
ON crownfield_eye_hospital.Prescription
TO 'doctor_role';

GRANT SELECT, INSERT, UPDATE
ON crownfield_eye_hospital.PrescriptionItem
TO 'doctor_role';

GRANT SELECT, INSERT, UPDATE
ON crownfield_eye_hospital.FollowUpPlan
TO 'doctor_role';

GRANT SELECT
ON crownfield_eye_hospital.Diagnosis
TO 'doctor_role';

GRANT SELECT
ON crownfield_eye_hospital.Medicine
TO 'doctor_role';

-- RECEPTIONIST: patient registration and scheduling
GRANT SELECT, INSERT, UPDATE
ON crownfield_eye_hospital.Patient
TO 'receptionist_role';

GRANT SELECT, INSERT, UPDATE
ON crownfield_eye_hospital.Appointment
TO 'receptionist_role';

GRANT SELECT
ON crownfield_eye_hospital.Clinician
TO 'receptionist_role';

GRANT SELECT
ON crownfield_eye_hospital.Clinic
TO 'receptionist_role';

-- PATIENT: appointment access only
-- Use a restricted view or application-level authorisation
-- to ensure patients can access only their own records.
GRANT SELECT
ON crownfield_eye_hospital.Appointment
TO 'patient_role';

-- Assign roles to existing database users
-- Replace usernames with accounts created by your administrator.
-- GRANT 'hospital_admin' TO 'admin_user'@'localhost';
-- GRANT 'doctor_role' TO 'doctor_user'@'localhost';
-- GRANT 'receptionist_role' TO 'receptionist_user'@'localhost';
-- GRANT 'patient_role' TO 'patient_user'@'localhost';


SHOW GRANTS FOR 'hospital_admin';
SHOW GRANTS FOR 'doctor_role';
SHOW GRANTS FOR 'receptionist_role';
SHOW GRANTS FOR 'patient_role';