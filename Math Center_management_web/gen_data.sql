-------------------------------------
-- SINH DỮ LIỆU MẪU------------------
-------------------------------------
--LỆNH TẠO 20000 HỌC VIÊN MẪU 
DO $$
DECLARE
    -- Mảng dữ liệu để tạo ngẫu nhiên
    last_names TEXT[] := ARRAY['Nguyễn', 'Trần', 'Lê', 'Phạm', 'Hoàng', 'Huỳnh', 'Vũ', 'Phan', 'Võ', 'Đặng', 'Bùi', 'Đỗ', 'Hồ', 'Ngô', 'Dương', 'Lý'];
    middle_names_m TEXT[] := ARRAY['Văn', 'Minh', 'Hữu', 'Đức', 'Công', 'Quang', 'Xuân', 'Ngọc', 'Đình'];
    middle_names_f TEXT[] := ARRAY['Thị', 'Ngọc', 'Thu', 'Phương', 'Mỹ', 'Khánh', 'Thùy', 'Bảo', 'Gia'];
    first_names_m TEXT[] := ARRAY['An', 'Bảo', 'Bình', 'Dũng', 'Duy', 'Hải', 'Hiếu', 'Huy', 'Khang', 'Khánh', 'Kiên', 'Lâm', 'Long', 'Mạnh', 'Minh', 'Nam', 'Nhật', 'Phong', 'Phúc', 'Quân', 'Sơn', 'Tài', 'Thắng', 'Thành', 'Toàn', 'Trung', 'Tuấn', 'Việt'];
    first_names_f TEXT[] := ARRAY['An', 'Anh', 'Bình', 'Châu', 'Chi', 'Dung', 'Giang', 'Hà', 'Hân', 'Hiền', 'Hoa', 'Hương', 'Lam', 'Lan', 'Linh', 'Ly', 'Mai', 'My', 'Nga', 'Ngân', 'Ngọc', 'Nhi', 'Oanh', 'Phương', 'Quyên', 'Thảo', 'Trang', 'Tú', 'Uyên', 'Vy'];
    streets TEXT[] := ARRAY['Cầu Giấy', 'Xuân Thủy', 'Láng', 'Tây Sơn', 'Nguyễn Trãi', 'Giải Phóng', 'Mỹ Đình', 'Lê Đức Thọ', 'Phạm Hùng', 'Trần Duy Hưng', 'Hoàng Quốc Việt', 'Kim Mã', 'Xã Đàn', 'Minh Khai'];

    -- Biến tạm (Đã sửa lỗi khai báo)
    v_full_name TEXT;
    v_gender CHAR(1);
    v_birth_day DATE;
    v_email TEXT;
    v_sdt TEXT;
    v_address TEXT;
    v_last_name TEXT;
    v_middle_name TEXT;
    v_first_name TEXT;
    
BEGIN
    FOR i IN 1..20000 LOOP
        -- Chọn giới tính ngẫu nhiên
        IF random() > 0.5 THEN
            v_gender := 'M';
            v_last_name := last_names[1 + floor(random() * array_length(last_names, 1))];
            v_middle_name := middle_names_m[1 + floor(random() * array_length(middle_names_m, 1))];
            v_first_name := first_names_m[1 + floor(random() * array_length(first_names_m, 1))];
        ELSE
            v_gender := 'F';
            v_last_name := last_names[1 + floor(random() * array_length(last_names, 1))];
            v_middle_name := middle_names_f[1 + floor(random() * array_length(middle_names_f, 1))];
            v_first_name := first_names_f[1 + floor(random() * array_length(first_names_f, 1))];
        END IF;

        -- Tạo tên đầy đủ
        v_full_name := v_last_name || ' ' || v_middle_name || ' ' || v_first_name;

        -- Tạo ngày sinh ngẫu nhiên (cho học sinh sinh năm 2007, 2008, 2009)
        v_birth_day := date '2007-01-01' + floor(random() * 365 * 3)::int;

        -- Tạo email đơn giản
        v_email := lower(regexp_replace(v_first_name, '\s+', '', 'g')) || '.' || lower(left(v_last_name, 1)) || i || '@email.com';

        -- Tạo SĐT ngẫu nhiên
        v_sdt := '0' || (ARRAY['3','5','7','8','9'])[1+floor(random()*5)] || (floor(random() * 90000000) + 10000000)::text;

        -- Tạo địa chỉ ngẫu nhiên
        v_address := (floor(random() * 200) + 1)::text || ' ' || streets[1 + floor(random() * array_length(streets, 1))];
        
        -- Chèn dữ liệu vào bảng
        INSERT INTO hoc_vien (full_name, gender, birth_day, email, sdt, address)
        VALUES (v_full_name, v_gender, v_birth_day, v_email, v_sdt, v_address);
    END LOOP;
END $$



-- SQL REPORT: TẬP LỆNH TẠO 1000 LỚP HỌC MẪU
DO $$
DECLARE
    -- Mảng dữ liệu để tạo tên lớp học
    class_prefixes TEXT[] := ARRAY['Luyện đề I-', 'Chuyên đề M-', 'Nền tảng O-', 'VIP 1-1 E-'];
    class_topics TEXT[] := ARRAY['Cấp Tốc', 'Mầm Non', 'A+', 'RTX', 'S+', '12', 'Trồi Non'];

    -- Biến tạm
    v_nv_id INTEGER;
    v_teacher_id INTEGER;
    v_type_id INTEGER;
    v_class_name TEXT;
    v_room INT;
    v_khai_giang DATE;
    v_ket_thuc DATE;
    v_price INTEGER;
    
BEGIN
    -- Thay đổi vòng lặp để tạo 1000 lớp
    FOR i IN 1..1000 LOOP
        -- Chọn ngẫu nhiên nhân viên phụ trách (giả sử có nv_id từ 1-490)
        v_nv_id := 1 + floor(random() * 490);

        -- Chọn ngẫu nhiên giáo viên (giả sử có teacher_id từ 1-490)
        v_teacher_id := 1 + floor(random() * 490);

        -- Lần lượt chọn type_id từ 1 đến 4
        v_type_id := 1 + ((i - 1) % 4);

        -- Cập nhật logic tạo phòng học ngẫu nhiên
        v_room := (1 + floor(random() * 5)) * 100 + floor(random() * 11);

        -- Tạo ngày khai giảng ngẫu nhiên từ 1/1/2023 đến ngày hiện tại
        v_khai_giang := date '2023-01-01' + (floor(random() * (CURRENT_DATE - date '2023-01-01')) * interval '1 day');
        
        -- Ngày kết thúc luôn cách ngày khai giảng đúng 3 tháng
        v_ket_thuc := v_khai_giang + interval '3 months';

        -- Tạo tên lớp học dựa trên loại lớp
        v_class_name := class_prefixes[v_type_id] || lpad(i::text, 2, '0') || ' - ' || class_topics[1 + floor(random() * array_length(class_topics, 1))];
        
        -- Gán giá tiền dựa trên loại lớp
        CASE v_type_id
            WHEN 1 THEN v_price := 3000000 + (floor(random() * 6) * 100000);  -- 3.0M -> 3.5M
            WHEN 2 THEN v_price := 3500000 + (floor(random() * 6) * 100000);  -- 3.5M -> 4.0M
            WHEN 3 THEN v_price := 2500000 + (floor(random() * 6) * 100000);  -- 2.5M -> 3.0M
            WHEN 4 THEN v_price := 6000000 + (floor(random() * 11) * 100000); -- 6.0M -> 7.0M
        END CASE;
        
        -- Chèn dữ liệu vào bảng clazz
        INSERT INTO clazz(nv_id, teacher_id, type_id, class_name, room, khai_giang, ket_thuc, price)
        VALUES (v_nv_id, v_teacher_id, v_type_id, v_class_name, v_room, v_khai_giang, v_ket_thuc, v_price);
    END LOOP;
END $$;



-- SQL REPORT: TẬP LỆNH TẠO 500 NHÂN VIÊN (DÙNG VÒNG LẶP)
DO $$
DECLARE
    -- Mảng dữ liệu để tạo ngẫu nhiên
    last_names TEXT[] := ARRAY['Nguyễn', 'Trần', 'Lê', 'Phạm', 'Hoàng', 'Bùi', 'Đỗ'];
    middle_names_m TEXT[] := ARRAY['Văn', 'Minh', 'Hữu', 'Đức', 'Công'];
    middle_names_f TEXT[] := ARRAY['Thị', 'Ngọc', 'Thu', 'Phương', 'Mỹ'];
    first_names_m TEXT[] := ARRAY['An', 'Bình', 'Dũng', 'Hải', 'Sơn', 'Tùng'];
    first_names_f TEXT[] := ARRAY['An', 'Cúc', 'Hà', 'Hương', 'Mai', 'Linh'];
    streets TEXT[] := ARRAY['Đống Đa', 'Cầu Giấy', 'Ba Đình', 'Hai Bà Trưng', 'Thanh Xuân', 'Hoàn Kiếm'];

    -- Biến tạm
    v_full_name TEXT;
    v_gender CHAR(1);
    v_birth_day DATE;
    v_email TEXT;
    v_sdt TEXT;
    v_address TEXT;
    v_last_name TEXT;
    v_middle_name TEXT;
    v_first_name TEXT;
    
BEGIN
    FOR i IN 1..500 LOOP
        IF random() > 0.5 THEN
            v_gender := 'M';
            v_last_name := last_names[1 + floor(random() * array_length(last_names, 1))];
            v_middle_name := middle_names_m[1 + floor(random() * array_length(middle_names_m, 1))];
            v_first_name := first_names_m[1 + floor(random() * array_length(first_names_m, 1))];
        ELSE
            v_gender := 'F';
            v_last_name := last_names[1 + floor(random() * array_length(last_names, 1))];
            v_middle_name := middle_names_f[1 + floor(random() * array_length(middle_names_f, 1))];
            v_first_name := first_names_f[1 + floor(random() * array_length(first_names_f, 1))];
        END IF;

        v_full_name := v_last_name || ' ' || v_middle_name || ' ' || v_first_name;
        v_birth_day := date '1995-01-01' + floor(random() * 365 * 6)::int; -- Tuổi từ 1995 -> 2000
        v_email := lower(regexp_replace(v_first_name, '\s+', '', 'g')) || '.' || lower(left(v_last_name, 1)) || i || '@trungtamtoan.vn';
        v_sdt := '0' || (ARRAY['90','91','98','97'])[1+floor(random()*4)] || (floor(random() * 9000000) + 1000000)::text;
        v_address := (floor(random() * 150) + 1)::text || ' ' || streets[1 + floor(random() * array_length(streets, 1))];
        
        INSERT INTO nhan_vien (full_name, gender, birth_day, email, sdt, address)
        VALUES (v_full_name, v_gender, v_birth_day, v_email, v_sdt, v_address);
    END LOOP;
END $$;



-- SQL REPORT: TẬP LỆNH TẠO 500 GIÁO VIÊN (DÙNG VÒNG LẶP)
DO $$
DECLARE
    -- Mảng dữ liệu để tạo ngẫu nhiên
    last_names TEXT[] := ARRAY['Nguyễn', 'Trần', 'Lê', 'Phạm', 'Hoàng', 'Vũ', 'Phan', 'Võ', 'Đặng', 'Bùi'];
    middle_names_m TEXT[] := ARRAY['Minh', 'Quang', 'Đức', 'Anh', 'Thành', 'Tuấn'];
    middle_names_f TEXT[] := ARRAY['Thị', 'Ngọc', 'Thùy', 'Khánh', 'Diệu', 'Mỹ'];
    first_names_m TEXT[] := ARRAY['Tuấn', 'Hải', 'Minh', 'Quang', 'Dũng', 'Sơn', 'Thắng'];
    first_names_f TEXT[] := ARRAY['Hoa', 'Anh', 'Hương', 'Vy', 'Linh', 'Trang', 'Huyền'];
    streets TEXT[] := ARRAY['Xuân Thủy', 'Nguyễn Trãi', 'Giải Phóng', 'Mỹ Đình', 'Láng Hạ', 'Kim Mã'];
    trinh_do_options TEXT[] := ARRAY['Cử nhân', 'Thạc Sĩ', 'Thạc Sĩ', 'Tiến Sĩ', 'Thạc Sĩ']; -- Tăng tỉ lệ Thạc sĩ

    -- Biến tạm
    v_full_name TEXT;
    v_gender CHAR(1);
    v_birth_day DATE;
    v_email TEXT;
    v_sdt TEXT;
    v_address TEXT;
    v_trinh_do TEXT;
    v_last_name TEXT;
    v_middle_name TEXT;
    v_first_name TEXT;

BEGIN
    FOR i IN 1..500 LOOP
        IF random() > 0.5 THEN
            v_gender := 'M';
            v_last_name := last_names[1 + floor(random() * array_length(last_names, 1))];
            v_middle_name := middle_names_m[1 + floor(random() * array_length(middle_names_m, 1))];
            v_first_name := first_names_m[1 + floor(random() * array_length(first_names_m, 1))];
        ELSE
            v_gender := 'F';
            v_last_name := last_names[1 + floor(random() * array_length(last_names, 1))];
            v_middle_name := middle_names_f[1 + floor(random() * array_length(middle_names_f, 1))];
            v_first_name := first_names_f[1 + floor(random() * array_length(first_names_f, 1))];
        END IF;

        v_full_name := v_last_name || ' ' || v_middle_name || ' ' || v_first_name;
        v_birth_day := date '1988-01-01' + floor(random() * 365 * 10)::int; -- Tuổi từ 1988 -> 1997
        v_email := lower(regexp_replace(v_first_name, '\s+', '', 'g')) || '.' || lower(left(v_last_name, 1)) || i || '@giaovien.edu.vn';
        v_sdt := '0' || (ARRAY['90','93','94','96'])[1+floor(random()*4)] || (floor(random() * 9000000) + 1000000)::text;
        v_address := (floor(random() * 200) + 50)::text || ' ' || streets[1 + floor(random() * array_length(streets, 1))];
        v_trinh_do := trinh_do_options[1 + floor(random() * array_length(trinh_do_options, 1))];

        INSERT INTO teacher (full_name, gender, birth_day, email, sdt, address, trinh_do)
        VALUES (v_full_name, v_gender, v_birth_day, v_email, v_sdt, v_address, v_trinh_do);
    END LOOP;
END $$;




-- SCHEDULE
DO $$
DECLARE
    -- Biến record để chứa từng dòng dữ liệu của bảng clazz khi lặp
    class_record RECORD;

    -- Mảng chứa các tùy chọn để tạo dữ liệu ngẫu nhiên
    day_options VARCHAR(2)[] := ARRAY['2', '3', '4', '5', '6', '7', 'CN'];
    time_options TIME[] := ARRAY['07:00:00','07:30:00','08:00:00','09:00:00','09:30:00','13:30:00','14:00:00','14:30:00','15:00:00','16:00:00','16:30:00','17:00:00','17:30:00','18:00:00','19:00:00','19:30:00'];
    
    -- Biến tạm
    v_days VARCHAR(2)[];
    v_start_time TIME;
    v_end_time TIME;
    v_is_conflict BOOLEAN;
    v_retry_count INTEGER;

BEGIN
    -- Vòng lặp FOR duyệt qua từng lớp học để gán lịch
    FOR class_record IN 
        SELECT class_id, room, teacher_id, khai_giang, ket_thuc FROM clazz 
    LOOP
    
        -- Chỉ thêm lịch học nếu lớp này chưa có trong bảng schedule
        IF NOT EXISTS (SELECT 1 FROM schedule WHERE class_id = class_record.class_id) THEN
            
            v_retry_count := 0;
            LOOP 
            
                -- 1. Tạo một lịch học "ứng viên" ngẫu nhiên
                v_days := ARRAY(SELECT day FROM unnest(day_options) AS t(day) ORDER BY random() LIMIT 3);
                v_start_time := time_options[1 + floor(random() * array_length(time_options, 1))];
                v_end_time := v_start_time + interval '2 hours';

                -- Một lịch bị coi là XUNG ĐỘT nếu nó trùng (NGÀY + GIỜ + KHOẢNG THỜI GIAN KHÓA HỌC)
                -- VÀ (trùng PHÒNG HỌC hoặc trùng GIÁO VIÊN)
                SELECT EXISTS (
                    SELECT 1
                    FROM schedule s
                    JOIN clazz c ON s.class_id = c.class_id
                    WHERE 
                        -- Điều kiện thời gian (phải thỏa mãn TẤT CẢ)
                        s.days && v_days -- A. Có chung ít nhất một ngày học
                        AND (s.start_time, s.end_time) OVERLAPS (v_start_time, v_end_time) -- B. Khung giờ bị trùng
                        AND (c.khai_giang, c.ket_thuc) OVERLAPS (class_record.khai_giang, class_record.ket_thuc) -- C. Khoảng thời gian khóa học bị trùng

        
                        AND (
                            c.room = class_record.room -- D1. Hoặc là trùng phòng
                            OR 
                            c.teacher_id = class_record.teacher_id -- D2. Hoặc là trùng giáo viên
                        )
                ) INTO v_is_conflict;

                -- 3. Nếu không trùng, thoát khỏi vòng lặp 
                IF NOT v_is_conflict THEN
                    EXIT; -- Thoát khỏi LOOP
                END IF;

                -- 4. Nếu bị trùng, tăng biến đếm và thử lại
                v_retry_count := v_retry_count + 1;
                IF v_retry_count > 200 THEN 
                    RAISE WARNING 'Không thể tìm thấy lịch trống cho lớp ID % sau 200 lần thử.', class_record.class_id;
                    v_days := NULL;
                    EXIT;
                END IF;

            END LOOP; 

            -- 5. Nếu đã tìm được lịch trống, thì INSERT
            IF v_days IS NOT NULL THEN
                INSERT INTO schedule (class_id, days, start_time, end_time)
                VALUES (class_record.class_id, v_days, v_start_time, v_end_time);
                RAISE NOTICE 'Đã gán lịch thành công cho lớp ID: %', class_record.class_id;
            END IF;

        END IF; 

    END LOOP; 

    RAISE NOTICE 'Hoàn tất quá trình gán lịch học.';

END $$;






-- ENROLLMENTS
DO $$
DECLARE
    -- Biến record để chứa từng dòng dữ liệu của bảng clazz
    class_record RECORD;
    
    -- Biến tạm
    v_student_id INTEGER;
    v_class_size INTEGER;
    v_enrollment_date DATE;
    v_minitest1 DECIMAL(4,2);
    v_minitest2 DECIMAL(4,2);
    v_minitest3 DECIMAL(4,2);
    v_minitest4 DECIMAL(4,2);
    v_midterm DECIMAL(4,2);
    v_final DECIMAL(4,2);

BEGIN
    -- Lặp qua từng lớp học để gán học viên
    FOR class_record IN SELECT class_id, khai_giang FROM clazz LOOP
    
        -- 1. Quyết định sĩ số ngẫu nhiên cho lớp này (ví dụ: từ 0 đến 30)
        v_class_size := 0 + floor(random() * 31); 

        -- 2. Lặp lại để thêm đủ số học viên cho lớp
        FOR i IN 1..v_class_size LOOP
        
            -- 3. Chọn một học viên ngẫu nhiên CHƯA CÓ trong lớp này
            SELECT student_id INTO v_student_id
            FROM hoc_vien
            WHERE student_id NOT IN (
                SELECT student_id FROM enrollments WHERE class_id = class_record.class_id
            )
            ORDER BY random()
            LIMIT 1;

            -- Nếu tìm được học viên phù hợp
            IF v_student_id IS NOT NULL THEN
            
                -- 4. Tạo dữ liệu ngẫu nhiên cho lượt đăng ký
                v_enrollment_date := class_record.khai_giang - (floor(random() * 15) + 1) * interval '1 day';
                v_minitest1 := round((0 + random() * 10)::numeric, 2);
                v_minitest2 := round((0 + random() * 10)::numeric, 2);
                v_minitest3 := round((0 + random() * 10)::numeric, 2);
                v_minitest4 := round((0 + random() * 10)::numeric, 2);
                v_midterm := round((0 + random() * 10)::numeric, 2);
                v_final := round((0 + random() * 10)::numeric, 2);
                
                -- 5. Chèn bản ghi vào bảng enrollments
                INSERT INTO enrollments (
                    student_id, class_id, enrollment_date, 
                    minitest1, minitest2, minitest3, minitest4, 
                    midterm, final
                )
                VALUES (
                    v_student_id, class_record.class_id, v_enrollment_date,
                    v_minitest1, v_minitest2, v_minitest3, v_minitest4,
                    v_midterm, v_final
                )
                ON CONFLICT (student_id, class_id) DO NOTHING;

            END IF;
            
        END LOOP; -- Kết thúc lặp để thêm học viên

        RAISE NOTICE 'Đã gán % học viên cho lớp ID: %', v_class_size, class_record.class_id;
        
    END LOOP; -- Kết thúc lặp qua các lớp học

    RAISE NOTICE 'Hoàn tất quá trình gán lượt đăng ký.';

END $$;


-- SQL REPORT: TẬP LỆNH TẠO DỮ LIỆU ĐIỂM DANH 
DO $$
DECLARE
    class_rec RECORD;
    student_rec RECORD;
    v_total_sessions_planned INT;
    v_session_dates DATE[] := ARRAY[]::DATE[];
    first_session_date DATE;
    v_current_date DATE;
    new_session_date DATE;
    day_of_week_num INT;
    v_target_absences INT;
    v_actual_absences INT;
    v_status_list TEXT[];
    v_shuffled_status_list TEXT[];
    v_actual_sessions_created INT;

BEGIN
    -- 1. Lặp qua từng lớp học
    FOR class_rec IN 
        SELECT c.class_id, c.khai_giang, c.ket_thuc, s.days 
        FROM clazz c
        JOIN schedule s ON c.class_id = s.class_id
    LOOP
        --  Chỉ xử lý nếu lớp có lịch học
        IF array_length(class_rec.days, 1) > 0 THEN
            
            v_total_sessions_planned := 9 + floor(random() * 3);

            -- Tìm ngày học hợp lệ đầu tiên
            first_session_date := NULL;
            v_current_date := class_rec.khai_giang;
            WHILE first_session_date IS NULL LOOP
                day_of_week_num := CAST(to_char(v_current_date, 'ID') AS INT); 
                IF (day_of_week_num::text = ANY(class_rec.days)) OR (day_of_week_num = 7 AND 'CN' = ANY(class_rec.days)) THEN
                    first_session_date := v_current_date; 
                END IF;
                v_current_date := v_current_date + interval '1 day'; 
            END LOOP;

            -- Tạo mảng các ngày học hợp lệ
            v_session_dates := ARRAY[]::DATE[];
            IF first_session_date IS NOT NULL THEN
                FOR i IN 0..(v_total_sessions_planned - 1) LOOP
                    new_session_date := first_session_date + (i * 7) * interval '1 day';
                    IF new_session_date <= class_rec.ket_thuc THEN
                        v_session_dates := array_append(v_session_dates, new_session_date);
                    ELSE
                        EXIT; 
                    END IF;
                END LOOP;
            END IF;

            v_actual_sessions_created := array_length(v_session_dates, 1);

            IF v_actual_sessions_created > 0 THEN
                -- Lặp qua từng học viên trong lớp
                FOR student_rec IN 
                    SELECT student_id FROM enrollments WHERE class_id = class_rec.class_id
                LOOP
                    v_target_absences := floor(random() * 11);
                    v_actual_absences := least(v_target_absences, v_actual_sessions_created);

                    v_status_list := array_fill('0'::text, ARRAY[v_actual_absences]);
                    v_status_list := v_status_list || array_fill('1'::text, ARRAY[v_actual_sessions_created - v_actual_absences]);

                    SELECT array_agg(status) INTO v_shuffled_status_list FROM (
                        SELECT unnest(v_status_list) AS status ORDER BY random()
                    ) AS shuffled;

                    FOR i IN 1..v_actual_sessions_created LOOP
                        INSERT INTO attendance (student_id, class_id, attendance_date, status)
                        VALUES (student_rec.student_id, class_rec.class_id, v_session_dates[i], v_shuffled_status_list[i]);
                    END LOOP;
                END LOOP;
            END IF;
        END IF; 
    END LOOP; 
    RAISE NOTICE 'Hoàn tất tạo dữ liệu điểm danh tùy chỉnh.';
END $$;



-- SQL REPORT: TẬP LỆNH TẠO DỮ LIỆU ĐÁNH GIÁ 
DO $$
DECLARE
    enrollment_rec RECORD;
    
    v_class_rate INTEGER;
    v_teacher_rate INTEGER;
BEGIN
    -- Lặp qua từng lượt đăng ký của học viên
    FOR enrollment_rec IN 
        SELECT e.student_id, e.class_id, c.teacher_id 
        FROM enrollments e
        JOIN clazz c ON e.class_id = c.class_id
    LOOP
        -- Chỉ có 90% cơ hội một học viên sẽ để lại feedback
        IF random() < 0.9 THEN
            
            -- floor(1 + random() * 10) sẽ cho kết quả là 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
            v_class_rate := floor(1 + random() * 10);
            v_teacher_rate := floor(1 + random() * 10);

            INSERT INTO feedback(student_id, class_id, teacher_id, class_rate, teacher_rate)
            VALUES (enrollment_rec.student_id, enrollment_rec.class_id, enrollment_rec.teacher_id, v_class_rate, v_teacher_rate);
        END IF;
    END LOOP; -- Hết lặp các lượt đăng ký
    RAISE NOTICE 'Hoàn tất tạo dữ liệu đánh giá (điểm số nguyên).';
END $$;


UPDATE enrollments
SET
    minitest1 = ROUND(minitest1, 1),
    minitest2 = ROUND(minitest2, 1),
    minitest3 = ROUND(minitest3, 1),
    minitest4 = ROUND(minitest4, 1),
    midterm   = ROUND(midterm, 1),
    final_test   = ROUND(final_test, 1);
