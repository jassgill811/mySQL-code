USE crownfield_eye_hospital;

SELECT
    c.clinician_id,
    c.clinician_name,
    COUNT(a.appointment_id) AS total_appointments
FROM Clinician c
INNER JOIN Appointment a
    ON c.clinician_id = a.clinician_id
GROUP BY c.clinician_id, c.clinician_name
HAVING COUNT(a.appointment_id) > 1
ORDER BY total_appointments DESC;


SELECT
    a.appointment_id,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    c.clinician_name,
    cl.clinic_name,
    a.appointment_datetime,
    a.appointment_status
FROM Appointment a
INNER JOIN Patient p
    ON a.patient_id = p.patient_id
INNER JOIN Clinician c
    ON a.clinician_id = c.clinician_id
INNER JOIN Clinic cl
    ON a.clinic_id = cl.clinic_id
ORDER BY a.appointment_datetime;


SELECT
    a.appointment_id,
    a.appointment_datetime,
    a.appointment_status,
    p.first_name,
    p.last_name,
    pr.prescription_id
FROM Appointment a
INNER JOIN Patient p
    ON a.patient_id = p.patient_id
LEFT JOIN Prescription pr
    ON a.appointment_id = pr.appointment_id
WHERE pr.prescription_id IS NULL;


SELECT
    p.patient_id,
    p.first_name,
    p.last_name,
    COUNT(a.appointment_id) AS total_appointments
FROM Patient p
LEFT JOIN Appointment a
    ON p.patient_id = a.patient_id
GROUP BY p.patient_id, p.first_name, p.last_name
HAVING COUNT(a.appointment_id) > (
    SELECT AVG(appointment_count)
    FROM (
        SELECT
            p2.patient_id,
            COUNT(a2.appointment_id) AS appointment_count
        FROM Patient p2
        LEFT JOIN Appointment a2
            ON p2.patient_id = a2.patient_id
        GROUP BY p2.patient_id
    ) AS patient_totals
);
