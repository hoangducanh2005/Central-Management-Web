-------------------------------------------------------------------
------------------------------------------------------------------
-------------------------------------------------------------------


CREATE OR REPLACE FUNCTION validate_schedule()
RETURNS TRIGGER AS $$
DECLARE
    v_new_khai_giang DATE;
    v_new_ket_thuc DATE;
    v_new_room INTEGER;
    v_teacher_id INTEGER;

    conflict_count INTEGER;
BEGIN

    SELECT c.khai_giang, c.ket_thuc, c.room, c.teacher_id
    INTO v_new_khai_giang, v_new_ket_thuc, v_new_room, v_teacher_id
    FROM clazz c
    WHERE c.class_id = NEW.class_id;

    ---
    --  room check
    ---
    SELECT COUNT(*)
    INTO conflict_count
    FROM schedule s
    JOIN clazz c ON s.class_id = c.class_id
    WHERE
        c.room = v_new_room
        AND s.class_id <> NEW.class_id
        AND s.days && NEW.days
        AND (NEW.start_time, NEW.end_time) OVERLAPS (s.start_time, s.end_time)
        AND (v_new_khai_giang, v_new_ket_thuc) OVERLAPS (c.khai_giang, c.ket_thuc);

    IF conflict_count > 0 THEN
        RAISE EXCEPTION 'Duplicate classrooms: Room % used in this time.', v_new_room;
    END IF;

    ---
    -- teacher schedule check
    ---
    SELECT COUNT(*)
    INTO conflict_count
    FROM schedule s
    JOIN clazz c ON s.class_id = c.class_id
    WHERE
        c.teacher_id = v_teacher_id
        AND s.class_id <> NEW.class_id
        AND s.days && NEW.days
        AND (NEW.start_time, NEW.end_time) OVERLAPS (s.start_time, s.end_time)
        AND (v_new_khai_giang, v_new_ket_thuc) OVERLAPS (c.khai_giang, c.ket_thuc);

    IF conflict_count > 0 THEN
        RAISE EXCEPTION 'Duplicate teacher schedule (ID: %)', v_teacher_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_validate_schedule
BEFORE INSERT OR UPDATE ON schedule
FOR EACH ROW
EXECUTE FUNCTION validate_schedule();

-------------------------------------------------------------------
------------------------------------------------------------------
-------------------------------------------------------------------
            CREATE OR REPLACE FUNCTION update_class_size()
            RETURNS TRIGGER AS $$
            BEGIN
                IF TG_OP = 'INSERT' THEN
                    UPDATE clazz 
                    SET si_so = si_so + 1
                    WHERE class_id = NEW.class_id;
                ELSIF TG_OP = 'DELETE' THEN
                    UPDATE clazz 
                    SET si_so = si_so - 1
                    WHERE class_id = OLD.class_id;
                END IF;
                RETURN NULL;
            END;
            $$ LANGUAGE plpgsql;
            
            CREATE TRIGGER update_class_size_trigger
            AFTER INSERT OR DELETE ON enrollments
            FOR EACH ROW
            EXECUTE FUNCTION update_class_size();
            
            
-- SĨ SỐ MAX LÀ 30          
CREATE OR REPLACE FUNCTION check_max_si_so()
RETURNS TRIGGER AS $$
DECLARE current_size INTEGER;
BEGIN
	SELECT si_so INTO current_size
	FROM clazz
	WHERE class_id = NEW.class_id;

	IF current_size >= 30 THEN
		RAISE NOTICE 'Class (ID= % ) is full (30) !! Can not add more student', NEW.class_id;
		RETURN NULL;
	END IF;

	RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER tg_check_max_si_so
BEFORE INSERT ON enrollments
FOR EACH ROW
EXECUTE FUNCTION check_max_si_so();