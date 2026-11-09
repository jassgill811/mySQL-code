USE crownfield_eye_hospital;
DROP PROCEDURE IF EXISTS GetPatientAppointments;
DELIMITER //
CREATE PROCEDURE GetPatientAppointments(
    IN p_patient_id INT
)
BEGIN
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
    WHERE p.patient_id = p_patient_id
    ORDER BY a.appointment_datetime DESC;
END //
DELIMITER ;
-- Execute the procedure for patient 1
CALL GetPatientAppointments(1);


DROP TRIGGER IF EXISTS ValidatePatientDOB_Insert;
DELIMITER //
CREATE TRIGGER ValidatePatientDOB_Insert
BEFORE INSERT ON Patient
FOR EACH ROW
BEGIN
    IF NEW.date_of_birth > CURRENT_DATE THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Date of birth cannot be in the future';
    END IF;
END //
DELIMITER ;

INSERT INTO Patient (
    first_name,
    last_name,
    postcode,
    date_of_birth
)
VALUES (
    'Test',
    'Patient',
    'AB1 2CD',
    '2099-01-01'
);