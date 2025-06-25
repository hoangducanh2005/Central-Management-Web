-----------------------------------------------------
-----------------------------------------------------
-- CÂU 1  -> 10 : Nguyễn Thành Bách - 20235660
-- CÂU 11 -> 20 : Hoàng Đức Anh     - 20235640
-- CÂU 21 -> 30 : Vũ Anh            - 20235657
-----------------------------------------------------
-----------------------------------------------------




--------------------------------------------------------
--------------------------------------------------------
--------------------------------------------------------
--Nguyễn Thành Bách - 20235660
--------------------------------------------------------
--------------------------------------------------------
--------------------------------------------------------

--CÂU 1: Danh sách học viên dùng sđt Vinaphone
--Cách 1:Dùng OR
SELECT student_id, full_name,sdt
FROM hoc_vien
WHERE sdt LIKE '091%' OR sdt LIKE '094%' OR sdt LIKE '088%' OR
      sdt LIKE '081%' OR sdt LIKE '082%' OR sdt LIKE '083%' OR
      sdt LIKE '084%' OR sdt LIKE '085%';

--Cách 2:Dùng Regular Expression
SELECT student_id,full_name,sdt
FROM hoc_vien
WHERE sdt ~ '^(091|094|088|081|082|083|084|085)';

--Cách 3:Dùng hàm SUBSTRING
SELECT student_id,full_name,sdt
FROM hoc_vien
WHERE SUBSTRING(sdt, 1, 3) IN ('091', '094', '088', '081', '082', '083', '084', '085');

CREATE INDEX idx_hocvien_sdt_prefix 
ON hoc_vien( (SUBSTRING(sdt, 1, 3)) );
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

--Câu 2: Tính doanh thu của trung tâm trong tháng 9/2023
--Cách 1: Dùng bảng tạm
WITH RevenuePerClass AS (
    SELECT c.class_id,c.price * c.si_so AS class_revenue
    FROM clazz c
    JOIN enrollments e USING(class_id)
    WHERE enrollment_date >= '2023-09-01' 
      AND enrollment_date < '2023-10-01'
    GROUP BY c.class_id
)
SELECT SUM(class_revenue) AS total_revenue
FROM RevenuePerClass;

CREATE INDEX idx_enrollment_date ON enrollments(enrollment_date);

--Cách 2:Dùng IN với Subquery
SELECT SUM(c.price * c.si_so) AS total_revenue
FROM clazz c
WHERE c.class_id IN (
        SELECT e.class_id 
        FROM enrollments e
        WHERE enrollment_date >= '2023-09-01' AND enrollment_date < '2023-10-01'
    );

CREATE INDEX idx_enrollment_date ON enrollments(enrollment_date);

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--Câu 3: Danh sách các lớp khai giảng trong tháng 1/2025
--Cách 1: Dùng hàm EXTRACT
SELECT c.class_name AS ten_lop_hoc,
	    c.khai_giang AS ngay_khai_giang,
	    t.full_name AS giao_vien_phu_trach,
	    c.price AS hoc_phi,
	    c.si_so
FROM clazz c
JOIN teacher t USING (teacher_id)
WHERE EXTRACT(YEAR FROM c.khai_giang) = 2025
    AND EXTRACT(MONTH FROM c.khai_giang) = 1;
    
CREATE INDEX idx_extract_year_month_khai_giang 
ON clazz(EXTRACT(YEAR FROM khai_giang),EXTRACT(MONTH FROM khai_giang))   

--Cách 2: Xét khoảng
SELECT c.class_name AS ten_lop_hoc,
	    c.khai_giang AS ngay_khai_giang,
	    t.full_name AS giao_vien_phu_trach,
	    c.price AS hoc_phi,
	    c.si_so
FROM clazz c
JOIN teacher t USING (teacher_id)
WHERE c.khai_giang >= '2025-01-01' AND c.khai_giang < '2025-02-01';

CREATE INDEX idx_khai_giang ON clazz(khai_giang)

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--CÂU 4: Danh sách mã học viên đã đăng ký các lớp loại I và O
--Cách 1: JOIN các bảng rồi kiểm tra điều kiện
SELECT student_id
FROM enrollments
JOIN clazz c USING (class_id)
JOIN class_type ct USING (type_id)
WHERE ct.code IN('I','O')
GROUP BY student_id
HAVING COUNT (DISTINCT ct.code)=2;

CREATE INDEX idx_clazz_type_id ON clazz(type_id);

--Cách 2: Dùng INTERSECT
SELECT student_id 
FROM enrollments
JOIN clazz c USING (class_id)
JOIN class_type ct USING (type_id)
WHERE ct.code = 'I'
INTERSECT
select student_id 
FROM enrollments
JOIN clazz c USING (class_id)
JOIN class_type ct USING (type_id)
WHERE ct.code = 'O';

CREATE INDEX idx_clazz_type_id ON clazz(type_id);


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--CÂU 5: Danh sách học viên có ít nhất 1 bài kiểm tra 0 điểm
--Cách 1:Dùng OR
SELECT h.student_id,h.full_name 
FROM hoc_vien h
JOIN enrollments USING (student_id)
WHERE minitest1 = 0 OR minitest2 = 0 OR minitest3=0 OR minitest4 = 0 OR midterm = 0 OR final_test = 0 
GROUP BY h.student_id;

--Cách 2: Biến thành các cột điểm thành 1 mảng
SELECT h.student_id,h.full_name 
FROM hoc_vien h
JOIN enrollments USING (student_id)
WHERE ARRAY[minitest1, minitest2, minitest3, minitest4, midterm,  final_test] @> ARRAY[0.00]
GROUP BY h.student_id;

CREATE INDEX idx_gin_enrollments_grades ON enrollments 
USING GIN((ARRAY[minitest1, minitest2, minitest3, minitest4, midterm, final_test]));


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--CÂU 6:Danh sách các lớp có giá cao nhất
--Cách 1: Dùng ALL
SELECT class_id, class_name,price
FROM clazz
WHERE price >= ALL (SELECT price FROM clazz);

--Cách 2: Dùng MAX
SELECT class_id, class_name,price
FROM clazz
WHERE price = (SELECT MAX(price) FROM clazz);

CREATE INDEX idx_price ON clazz(price)


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--CÂU 7:View  hiển thị top 10 học viên điểm tổng kết cao nhất 
--( bằng nhau thì xếp theo tên )

CREATE VIEW top_10_student_final_scores AS
SELECT hv.full_name as student_name, hv.student_id, e.class_id,
       ROUND(
        (e.minitest1 + e.minitest2 + e.minitest3 + e.minitest4) / 4.0 * 0.4 +
            e.midterm * 0.3 + e.final_test * 0.3
        , 2) as final_score
FROM hoc_vien hv
JOIN enrollments e USING(student_id)
WHERE (e.minitest1, e.minitest2, e.minitest3, e.minitest4, e.midterm, e.final_test) IS NOT NULL
ORDER BY final_score DESC,student_name ASC
LIMIT 10;


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--CÂU 8:Danh sách các lớp chưa có feedback nào ( đã kết thúc )
--Cách 1:Dùng NOT EXIST
SELECT c.class_id,c.class_name,c.ket_thuc  
FROM clazz c  
WHERE c.ket_thuc < CURRENT_DATE AND 
      NOT EXISTS (
	        SELECT 1
	        FROM feedback f 
	        WHERE f.class_id = c.class_id  
	    );
	    
--Cách 2:Dùng LEFT JOIN
SELECT c.class_id,c.class_name,c.ket_thuc 
FROM clazz c  
LEFT JOIN feedback f ON c.class_id = f.class_id
WHERE c.ket_thuc < CURRENT_DATE AND f.id_feedback IS NULL; 


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--CÂU 9:Danh sách các sinh viên tên "Giang"
--Cách 1:Dùng các Array Functio
SELECT * FROM hoc_vien
WHERE split_part(full_name, ' ', array_length(string_to_array(full_name, ' '), 1)) = 'Giang';

--Cách 2:Dùng LIKE
SELECT * FROM hoc_vien 
WHERE full_name LIKE '%Giang';

CREATE INDEX idx_hv_full_name_trgm 
ON hoc_vien USING GIN (full_name gin_trgm_ops);


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--CÂU 10:Danh sách các lớp tại phòng 201 kết thúc trong 3 tháng đầu năm 2025 

SELECT class_id,class_name,ket_thuc
FROM clazz
WHERE room = 201
      AND ket_thuc BETWEEN '2025-01-31' AND '2025-03-31'; 
      
 CREATE INDEX idx_room_end ON clazz(room,ket_thuc);
 

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--Hoàng Đức Anh - 20235640
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

--Câu 11: Tính phần trăm tham gia lớp học ( điểm danh ) của học sinh có student.id là {18282}
SELECT
    a.student_id,
    COUNT(*) FILTER (WHERE a.status = '1') AS di_hoc,
    COUNT(a.attendance_date) AS tong_so_buoi,
    ROUND(
        (COUNT(*) FILTER (WHERE a.status = '1')::DECIMAL / COUNT(a.id_attend)::DECIMAL * 100),
        2
    ) AS phan_tram_tham_gia
FROM attendance AS a
WHERE a.student_id = 18282
GROUP BY student_id;

CREATE INDEX idx_attendance_student_id ON attendance (student_id);

--Câu 12: Học sinh có điểm tổng kết cao nhất trong lớp có class\_{id} = 1000
--Sử dụng bảng CTE để tính điểm trước, sau đó dùng MAX
WITH final_grade AS (
    SELECT e.student_id, hv.full_name, e.class_id,
        ROUND(
            (e.minitest1 + e.minitest2 + e.minitest3 + e.minitest4) / 4 * 0.40
            + e.midterm * 0.30
            + e.final * 0.30
        ,2) AS calculated_final_grade
    FROM enrollments e
    JOIN hoc_vien hv ON e.student_id = hv.student_id 
    WHERE e.class_id = 1000
)
SELECT
    cg.student_id,
    cg.full_name,
    cg.calculated_final_grade
FROM final_grade cg
WHERE cg.calculated_final_grade = (
        SELECT MAX(calculated_final_grade)
        FROM final_grade
    );

CREATE INDEX idx_enrollments_class_id ON enrollments (class_id);

--Câu 13: Danh sách các lớp 'O' có giờ học buổi tối (từ 18h)
--Cách 1 : Sử dụng NOT IN và AND
SELECT c.class_name, s.start_time, s.end_time, s.days, c.room
FROM schedule AS s
JOIN clazz AS c ON s.class_id = c.class_id
JOIN class_type AS ct ON c.type_id = ct.type_id
WHERE ct.code NOT IN ('M', 'I', 'E') AND s.start_time >= '18:00:00'
ORDER BY s.start_time, c.class_name;

--Cách 2: Sử dụng Index và không dùng NOT IN
SELECT c.class_name, s.start_time, s.end_time, s.days, c.room
FROM schedule AS s
JOIN clazz AS c ON s.class_id = c.class_id
JOIN class_type AS ct ON c.type_id = ct.type_id
WHERE s.start_time >='18:00:00'
AND ct.code = 'O'
ORDER BY s.start_time, c.class_name;

CREATE INDEX idx_schedule_start_time ON schedule (start_time);

--Câu 14: Danh sách học sinh không đăng kí lớp học nào
--Cách 1:  Sử dụng NOT EXIST và SUB QUERRY
SELECT hv.student_id, hv.full_name
FROM hoc_vien AS hv
WHERE NOT EXISTS (
        SELECT e.student_id 
        FROM enrollments AS e
        WHERE e.student_id = hv.student_id
    );

--Cách 2: Sử dụng NOT IN và SUB QUERRY
SELECT hv.student_id, hv.full_name
FROM hoc_vien AS hv
WHERE hv.student_id NOT IN (
        SELECT student_id
        FROM enrollments
    );
    
--Câu 15: Danh sách lớp có ít học sinh nhất
--Cách 1: Sử dụng <= ALL
SELECT e.class_id, COUNT(DISTINCT e.student_id) AS total_students
FROM enrollments AS e
GROUP BY e.class_id
HAVING
    COUNT(DISTINCT e.student_id) <= ALL (
        SELECT COUNT(DISTINCT student_id)
        FROM enrollments
        GROUP BY class_id
    );
    
--Cách 2: Sử dụng MIN và SUB QUERRY
SELECT e.class_id, COUNT(DISTINCT e.student_id) AS total_students
FROM enrollments AS e
GROUP BY e.class_id
HAVING
    COUNT(DISTINCT e.student_id) = (
        SELECT MIN(student_count)
        FROM (
            SELECT COUNT(DISTINCT student_id) AS student_count
            FROM enrollments
            GROUP BY class_id
        ) AS subquery_counts
    );
    
CREATE INDEX idx_enrollments_class_student ON enrollments (class_id, student_id);

--Câu 16: Tạo view hiển thị thông tin giáo viên cùng đánh giá trung bình về giáo viên
--
CREATE VIEW teacher_rating AS
SELECT  f.teacher_id, t.full_name, 
           ROUND(AVG(f.teacher_rate), 2) AS average_teacher_rate
FROM feedback AS f
JOIN teacher t
USING (teacher_id)
GROUP BY  f.teacher_id,t.full_name
ORDER BY AVG(f.teacher_rate) DESC  ;

--Câu 17: Tính tổng học phí của học sinh có student\_id = 855
--Sử dụng SUM, JOIN và WHERE
SELECT hv.student_id, hv.full_name, SUM(c.price) AS tuition_fees
FROM hoc_vien AS hv
JOIN enrollments AS e ON hv.student_id = e.student_id
JOIN clazz AS c ON e.class_id = c.class_id
WHERE  hv.student_id = 855
GROUP BY  hv.student_id, hv.full_name;

--Câu 18: Tính doanh thu mà các giáo viên mang lại cho trung tâm trong năm 2023
--Dùng CTE - bảng tạm
WITH stu_per_class AS (
    SELECT e.class_id, COUNT(DISTINCT e.student_id) AS num_students
    FROM enrollments e
    GROUP BY e.class_id
),
ClassIncome AS (
    SELECT
        c.teacher_id,
        (c.price * spc.num_students) AS class_total_income
    FROM clazz c
    JOIN stu_per_class spc using(class_id)
    WHERE
        EXTRACT(YEAR FROM c.khai_giang) = 2023 
        AND EXTRACT(YEAR FROM c.ket_thuc) = 2023 
)
SELECT t.teacher_id,t.full_name, SUM(CI.class_total_income) AS total_income
FROM teacher t
JOIN ClassIncome CI using(teacher_id)
GROUP BY t.full_name,t.teacher_id
ORDER BY total_income DESC;

-- Dùng SUM
SELECT t.teacher_id,t.full_name, SUM(c.price) AS total_income
FROM teacher t
JOIN clazz c ON t.teacher_id = c.teacher_id
JOIN enrollments e ON c.class_id = e.class_id
WHERE  EXTRACT(YEAR FROM c.khai_giang) = 2023
    AND EXTRACT(YEAR FROM c.ket_thuc) = 2023
GROUP BY t.full_name,t.teacher_id
ORDER BY total_income DESC;


--Câu 19: Danh sách học sinh có sự tiến bộ trong học tập tại các lớp năm 2024
--Cách 1: Sử dụng phép so sánh trực tiếp
SELECT hv.student_id, hv.full_name, c.class_name
FROM hoc_vien AS hv
JOIN enrollments AS e ON hv.student_id = e.student_id
JOIN clazz AS c ON e.class_id = c.class_id
WHERE
    khai_giang >= '2024-01-01'
    AND ket_thuc <= '2024-12-31'
    AND e.final > e.midterm
    AND e.minitest1 <= e.minitest2
    AND e.minitest2 <= e.minitest3
    AND e.minitest3 <= e.minitest4;

--Cách 2: Sử dụng EXTRACT
SELECT hv.student_id, hv.full_name, c.class_name
FROM hoc_vien AS hv
JOIN enrollments AS e ON hv.student_id = e.student_id
JOIN clazz AS c ON e.class_id = c.class_id
WHERE
    EXTRACT(YEAR FROM c.khai_giang) = 2024
    AND EXTRACT(YEAR FROM c.ket_thuc) = 2024
    AND e.final > e.midterm
    AND e.minitest1 <= e.minitest2
    AND e.minitest2 <= e.minitest3
    AND e.minitest3 <= e.minitest4;

--Câu 20:Danh sách các giáo viên có tên “Anh”  và tổng số lớp có tiết Chủ Nhật mà họ dạy trong năm 2023
--Sử dụng ANY với mảng và COUNT DISTINCT
SELECT t.teacher_id, t.full_name, COUNT(DISTINCT c.class_id) AS total_Sundayclasses
FROM teacher t
JOIN clazz c ON t.teacher_id = c.teacher_id
JOIN schedule AS s ON c.class_id = s.class_id
WHERE
    EXTRACT(YEAR FROM c.khai_giang) = 2023
    AND EXTRACT(YEAR FROM c.ket_thuc) = 2023
    AND 'CN' = ANY(s.days)
    AND t.full_name LIKE '%Anh'
    GROUP BY
    t.teacher_id, t.full_name
ORDER BY
    total_Sundayclasses DESC;








--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--Vũ Anh - 20235657
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

--Câu 21: Tính tổng doanh thu theo loại lớp trong 6 tháng qua
--Cách 1: Dùng SUM and JOIN
SELECT ct.describe, SUM(c.price * c.si_so) AS total_revenue
FROM class_type ct
JOIN clazz c ON ct.type_id = c.type_id
JOIN enrollments e ON c.class_id = e.class_id
WHERE e.enrollment_date >= '2024-12-13'
GROUP BY ct.describe;

CREATE INDEX idx_enrollments_enrollment_date ON enrollments(enrollment_date);
--Cách 2:Dùng CTE
WITH class_revenue AS (
    SELECT ct.describe, c.price * c.si_so AS revenue
    FROM class_type ct
    JOIN clazz c ON ct.type_id = c.type_id
    JOIN enrollments e ON c.class_id = e.class_id
    WHERE e.enrollment_date >= CURRENT_DATE - INTERVAL '6 months'
)
SELECT describe, SUM(revenue) AS total_revenue
FROM class_revenue
GROUP BY describe;

CREATE INDEX idx_enrollments_enrollment_date ON enrollments(enrollment_date);
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--Câu 22: Tính trung bình điểm midterm của học viên theo từng giáo viên
--Cách 1: Dùng AVG and JOIN
SELECT t.full_name, AVG(e.midterm) AS avg_midterm
FROM teacher t
JOIN clazz c ON t.teacher_id = c.teacher_id
JOIN enrollments e ON c.class_id = e.class_id
GROUP BY t.full_name;

--Cách 2:Dùng Subquery
SELECT t.full_name, avg_midterm
FROM teacher t
JOIN (
    SELECT c.teacher_id, AVG(e.midterm) AS avg_midterm
    FROM clazz c
    JOIN enrollments e ON c.class_id = e.class_id
    GROUP BY c.teacher_id
) e ON t.teacher_id = e.teacher_id;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--Câu 23: Tổng số học viên đăng ký lớp quý 2 năm 2023
--Cách 1: Dùng COUNT and JOIN
SELECT c.class_name, COUNT(e.student_id) AS enrolled_count
FROM clazz c
JOIN enrollments e ON c.class_id = e.class_id
WHERE e.enrollment_date BETWEEN '2023-04-01' AND '2023-06-15'
GROUP BY c.class_name;

CREATE INDEX idx_enrollments_date ON enrollments (enrollment_date);

--Cách 2:Dùng subquery
SELECT c.class_name, (
    SELECT COUNT(e.student_id)
    FROM enrollments e
    WHERE e.class_id = c.class_id
    AND e.enrollment_date BETWEEN '2023-04-01' AND '2023-06-30'
) AS total_enrolled
FROM clazz c
WHERE c.khai_giang BETWEEN '2023-04-01' AND '2023-06-30';

CREATE INDEX idx_enrollments_class_date ON enrollments (class_id, enrollment_date);
CREATE INDEX idx_clazz_khai_giang ON clazz (khai_giang);
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--Câu 24: Trung bình điểm midterm trong quý 4 năm 2024 theo loại lớp
--Cách 1: Dùng AVG and JOIN
SELECT ct.describe, AVG(e.midterm) AS avg_midterm
FROM class_type ct
JOIN clazz c ON ct.type_id = c.type_id
JOIN enrollments e ON c.class_id = e.class_id
WHERE c.khai_giang BETWEEN '2024-10-01' AND '2024-12-31'
GROUP BY ct.describe;

CREATE INDEX idx_enrollments_class_midterm ON enrollments (class_id, midterm);

--Cách 2:Dùng Subquery
SELECT ct.describe, avg_midterm
FROM class_type ct
JOIN (
    SELECT c.type_id, AVG(e.midterm) AS avg_midterm
    FROM clazz c
    JOIN enrollments e ON c.class_id = e.class_id
    WHERE c.khai_giang BETWEEN '2024-10-01' AND '2024-12-31'
    GROUP BY c.type_id
) e ON ct.type_id = e.type_id;

CREATE INDEX idx_enrollments_class_midterm ON enrollments (class_id, midterm);
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--Câu 25: Tổng số học viên vắng mặt trong quý 4 năm 2024
--Cách 1: Dùng COUNT and JOIN
SELECT c.class_name, COUNT(a.student_id) AS absent_count
FROM clazz c
JOIN attendance a ON c.class_id = a.class_id
WHERE a.attendance_date BETWEEN '2024-01-01' AND '2024-03-31'
AND a.status = '1'
GROUP BY c.class_name;

CREATE INDEX idx_attendance_date_absent ON attendance (attendance_date, status);
--Cách 2:Dùng subquery
SELECT c.class_name, absent_count
FROM clazz c
JOIN (
    SELECT class_id, COUNT(*) AS absent_count
    FROM attendance
    WHERE attendance_date BETWEEN '2024-01-01' AND '2024-03-31'
    AND status = '1'
    GROUP BY class_id
) a ON c.class_id = a.class_id;

CREATE INDEX idx_attendance_date_absent ON attendance (attendance_date, status);
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--Câu 26: Danh sách lớp có sĩ số thay đổi trong quý 3/2023
--Cách 1: Dùng AVG and JOIN
SELECT c.class_name, c.si_so
FROM clazz c
WHERE EXISTS (
    SELECT 1 FROM enrollments e
    WHERE e.class_id = c.class_id
    AND e.enrollment_date BETWEEN '2023-07-01' AND '2023-09-30'
);

CREATE INDEX idx_enrollments_enroll_date ON enrollments (enrollment_date);
--Cách 2:Dùng Subquery
SELECT c.class_name, c.si_so
FROM clazz c
JOIN enrollments e ON c.class_id = e.class_id
WHERE e.enrollment_date BETWEEN '2023-07-01' AND '2023-09-30'
GROUP BY c.class_name, c.si_so
HAVING c.si_so > 0;

CREATE INDEX idx_enrollments_enroll_date ON enrollments (enrollment_date);
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--CÂU 27:View hiển thị các lớp đầy trong quý 2/2023
CREATE VIEW vw_full_classes AS
SELECT c.class_id, c.class_name, c.si_so, c.khai_giang
FROM clazz c
WHERE c.khai_giang BETWEEN '2023-04-01' AND '2023-06-15'
AND c.si_so = 30
WITH CHECK OPTION;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--CÂU 28:View hiển thị các học sinh vắng mặt trong tháng 6/2024
CREATE VIEW vw_absent_students AS
SELECT hv.student_id, hv.full_name, c.class_name, a.attendance_date
FROM hoc_vien hv
JOIN attendance a ON hv.student_id = a.student_id
JOIN clazz c ON a.class_id = c.class_id
WHERE a.attendance_date BETWEEN '2024-06-01' AND '2024-06-30'
AND a.status = '1';
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--Câu 29: Thứ hạng điểm tổng kết của học viên trong mỗi lớp quý 2 năm 2024
--Sử dụng RANK
SELECT hv.full_name, c.class_name,
       ROUND(((e.minitest1 + e.minitest2 + e.minitest3 + e.minitest4) * 0.4 +
              e.midterm * 0.3 + e.final_test * 0.3), 2) AS diem_tong_ket,
       RANK() OVER (PARTITION BY c.class_id ORDER BY ROUND(((e.minitest1 + e.minitest2 + e.minitest3 + e.minitest4) * 0.4 +
              e.midterm * 0.3 + e.final_test * 0.3), 2) DESC) AS rank
FROM hoc_vien hv
JOIN enrollments e ON hv.student_id = e.student_id
JOIN clazz c ON e.class_id = c.class_id
WHERE c.khai_giang BETWEEN '2024-04-01' AND '2024-06-24';
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--CÂU 30: Thông tin chi tiết về lịch học của từng lớp trong tháng 05/2024
--Sử dụng CROSS JOIN LATERAL
SELECT c.class_name, s.days, s.start_time, s.end_time
FROM clazz c
CROSS JOIN LATERAL (
    SELECT days, start_time, end_time
    FROM schedule s
    WHERE s.class_id = c.class_id
    AND c.khai_giang BETWEEN '2024-05-01' AND '2024-05-24'
) s;






























