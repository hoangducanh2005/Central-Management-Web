from django.db import models
from django.contrib.postgres.fields import ArrayField

class nhan_vien(models.Model):
    nv_id = models.AutoField(primary_key=True, verbose_name="Mã Nhân Viên")
    full_name = models.CharField(max_length=40, verbose_name="Họ và Tên")
    gender = models.CharField(max_length=1, verbose_name="Giới tính")
    birth_day = models.DateField(verbose_name="Ngày sinh")
    email = models.EmailField(max_length=40, verbose_name="Email")
    sdt = models.CharField(max_length=15, verbose_name="Số điện thoại")
    address = models.CharField(max_length=30, verbose_name="Địa chỉ")

    def __str__(self):
        return f"{self.full_name} ({self.nv_id})"

    class Meta:
        verbose_name = "Nhân Viên"
        verbose_name_plural = "Nhân Viên"
        db_table = 'nhan_vien'
        constraints = [
            models.CheckConstraint(
                check=models.Q(gender__in=['M', 'F']),
                name='nhan_vien_gender_valid'
            ),
        ]

class teacher(models.Model):
    teacher_id = models.AutoField(primary_key=True, verbose_name="Mã Giáo Viên")
    full_name = models.CharField(max_length=40, verbose_name="Họ và Tên")
    gender = models.CharField(max_length=1, verbose_name="Giới tính") 
    birth_day = models.DateField(verbose_name="Ngày sinh")
    email = models.EmailField(max_length=40,  verbose_name="Email")
    sdt = models.CharField(max_length=15, verbose_name="Số điện thoại")
    address = models.CharField(max_length=30, verbose_name="Địa chỉ")
    trinh_do = models.CharField(max_length=10, verbose_name="Trình độ" , default="Cử nhân") 

    def __str__(self):
        return f"{self.full_name} ({self.teacher_id})"

    class Meta:
        verbose_name = "Giáo Viên"
        verbose_name_plural = "Giáo Viên"
        db_table = 'teacher'
        constraints = [
            models.CheckConstraint(
                check=models.Q(gender__in=['M', 'F']),
                name='giao_vien_gender_valid'
            ),
            models.CheckConstraint(
                check=models.Q(trinh_do__in=['Cử nhân', 'Thạc Sĩ', 'Tiến Sĩ']),
                name='teacher_trinh_do_valid'
            ),
        ]

class hoc_vien(models.Model):
    student_id = models.AutoField(primary_key=True, verbose_name="Mã Học Viên")
    full_name = models.CharField(max_length=40, verbose_name="Họ và Tên")
    gender = models.CharField(max_length=1, verbose_name="Giới tính") 
    birth_day = models.DateField(verbose_name="Ngày sinh")
    email = models.EmailField(max_length=40,  verbose_name="Email")
    sdt = models.CharField(max_length=15, verbose_name="Số điện thoại")
    address = models.CharField(max_length=30, verbose_name="Địa chỉ")

    def __str__(self):
        return f"{self.full_name} ({self.student_id})"

    class Meta:
        verbose_name = "Học Viên"
        verbose_name_plural = "Học Viên"
        db_table = 'hoc_vien'
        constraints = [
            models.CheckConstraint(
                check=models.Q(gender__in=['M', 'F']),
                name='hoc_vien_gender_valid'
            ),
        ]

class class_type(models.Model):
    type_id = models.AutoField(primary_key=True, verbose_name="Mã loại lớp")
    describe = models.TextField(verbose_name="Mô tả")
    code = models.CharField(max_length=1, verbose_name="Mã code")  # Ví dụ: 'O', 'M', ...

    def __str__(self):
        return f"{self.code} - {self.describe}"

    class Meta:
        db_table = 'class_type'


class clazz(models.Model):
    class_id = models.AutoField(primary_key=True, verbose_name="Mã Lớp học")
    nhan_vien = models.ForeignKey(nhan_vien, on_delete=models.PROTECT, db_column='nv_id', verbose_name="Nhân viên quản lý")
    teacher = models.ForeignKey(teacher, on_delete=models.PROTECT, db_column='teacher_id', verbose_name="Giáo viên")
    type = models.ForeignKey(class_type, on_delete=models.PROTECT, db_column='type_id', verbose_name="Loại lớp")
    class_name = models.CharField(max_length=40, verbose_name="Tên lớp học")
    room = models.IntegerField(verbose_name="Phòng học")
    khai_giang = models.DateField(verbose_name="Ngày khai giảng")
    ket_thuc = models.DateField(verbose_name="Ngày kết thúc")
    si_so = models.IntegerField(verbose_name="Sĩ số hiện tại", default=0)
    price = models.IntegerField(verbose_name="Học phí")

    def __str__(self):
        return f"{self.class_name} ({self.class_id})"

    class Meta:
        verbose_name = "Lớp Học"
        verbose_name_plural = "Lớp Học"
        db_table = 'clazz'


DAY_CHOICES = [
    ('2', 'Thứ 2'),
    ('3', 'Thứ 3'),
    ('4', 'Thứ 4'),
    ('5', 'Thứ 5'),
    ('6', 'Thứ 6'),
    ('7', 'Thứ 7'),
    ('CN', 'Chủ nhật'),
]

class schedule(models.Model):
    id_schedule = models.AutoField(primary_key=True, verbose_name="Mã Lịch học")
    class_obj = models.OneToOneField(clazz, on_delete=models.CASCADE, db_column='class_id', related_name='schedule', verbose_name="Lớp học", null=False)
    days = ArrayField(
        models.CharField(max_length=2, choices=DAY_CHOICES),
        size=3,  # Chỉ cho phép đúng 3 phần tử
        verbose_name="Các ngày trong tuần",
        null=False
    )
    start_time = models.TimeField(verbose_name="Thời gian bắt đầu", null=False)
    end_time = models.TimeField(verbose_name="Thời gian kết thúc", null=False)

    def __str__(self):
        return f"Lịch học {self.id_schedule} cho lớp {self.class_obj.class_name}"

    class Meta:
        verbose_name = "Lịch Học"
        verbose_name_plural = "Lịch Học"
        db_table = 'schedule'

class enrollments(models.Model):
    id = models.AutoField(primary_key=True)
    # Composite primary key với student_id và class_id
    student = models.ForeignKey(hoc_vien, on_delete=models.CASCADE, db_column='student_id', verbose_name="Học viên")
    class_obj = models.ForeignKey(clazz, on_delete=models.CASCADE, db_column='class_id', verbose_name="Lớp học")
    enrollment_date = models.DateField(verbose_name="Ngày đăng ký")
    minitest1 = models.DecimalField(null=True, blank=True, max_digits=4, decimal_places=2, verbose_name="Điểm minitest 1")
    minitest2 = models.DecimalField(null=True, blank=True, max_digits=4, decimal_places=2, verbose_name="Điểm minitest 2")
    minitest3 = models.DecimalField(null=True, blank=True, max_digits=4, decimal_places=2, verbose_name="Điểm minitest 3")
    minitest4 = models.DecimalField(null=True, blank=True, max_digits=4, decimal_places=2, verbose_name="Điểm minitest 4")
    midterm   = models.DecimalField(null=True, blank=True, max_digits=4, decimal_places=2, verbose_name="Điểm giữa kỳ")
    final_test     = models.DecimalField(null=True, blank=True, max_digits=4, decimal_places=2, verbose_name="Điểm cuối kỳ")

    def __str__(self):
        return f"{self.student.full_name} đăng ký lớp {self.class_obj.class_name}"

    class Meta:
        verbose_name = "Đăng Ký Học"
        verbose_name_plural = "Đăng Ký Học"
        db_table = 'enrollments'
        unique_together = (('student', 'class_obj'),)  # Đảm bảo không trùng học viên trong cùng lớp
        constraints = [
            models.CheckConstraint(check=(models.Q(minitest1__gte=0, minitest1__lte=10) | models.Q(minitest1__isnull=True)),name='minitest1_in_range'),
            models.CheckConstraint(check=(models.Q(minitest2__gte=0, minitest2__lte=10) |models.Q(minitest2__isnull=True)),name='minitest2_in_range'),
            models.CheckConstraint(check=(models.Q(minitest3__gte=0, minitest3__lte=10) |models.Q(minitest3__isnull=True)),name='minitest3_in_range'),
            models.CheckConstraint(check=(models.Q(minitest4__gte=0, minitest4__lte=10) |models.Q(minitest4__isnull=True)),name='minitest4_in_range'),
            models.CheckConstraint(check=(models.Q(midterm__gte=0, midterm__lte=10) |models.Q(midterm__isnull=True)),name='midterm_in_range'),
            models.CheckConstraint(check=(models.Q(final_test__gte=0, final_test__lte=10) |models.Q(final_test__isnull=True)),name='final_in_range'),
        ]
 
class attendance(models.Model):
    id_attend = models.AutoField(primary_key=True, verbose_name="Mã Điểm danh")
    student = models.ForeignKey(hoc_vien, on_delete=models.CASCADE, db_column='student_id', verbose_name="Học viên", null=False)
    class_obj = models.ForeignKey(clazz, on_delete=models.CASCADE, db_column='class_id', verbose_name="Lớp học", null=False)
    attendance_date = models.DateField(verbose_name="Ngày điểm danh", null=False)
    status = models.CharField(max_length=1, verbose_name="Trạng thái", null=False) 

    def __str__(self):
        return f"Điểm danh {self.student.full_name} - Lớp {self.class_obj.class_name} - Ngày {self.attendance_date}"

    class Meta:
        verbose_name = "Điểm Danh"
        verbose_name_plural = "Điểm Danh"
        db_table = 'attendance'
        constraints = [
            models.CheckConstraint(
                check=models.Q(status__in=['0', '1']),
                name='status_valid'
            ),
        ]

class feedback(models.Model):
    id_feedback = models.AutoField(primary_key=True, verbose_name="Mã Feedback")
    student = models.ForeignKey(hoc_vien, on_delete=models.PROTECT, db_column='student_id', verbose_name="Học viên", null=False)
    class_obj = models.ForeignKey(clazz, on_delete=models.PROTECT, db_column='class_id', verbose_name="Lớp học", null=False)
    teacher = models.ForeignKey(teacher, on_delete=models.PROTECT, db_column='teacher_id', verbose_name="Giáo viên", null=False)
    class_rate = models.DecimalField(max_digits=4, decimal_places=2, verbose_name="Đánh giá lớp học", null=False) # Thang điểm 1-10
    teacher_rate = models.DecimalField(max_digits=4, decimal_places=2, verbose_name="Đánh giá giáo viên", null=False) # Thang điểm 1-10
 
    def __str__(self):
        return f"Feedback {self.id_feedback} từ {self.student.full_name} cho lớp {self.class_obj.class_name}"

    class Meta:
        verbose_name = "Feedback"
        verbose_name_plural = "Feedback"
        db_table = 'feedback'
        constraints = [
            models.CheckConstraint(
                check=(
                    models.Q(class_rate__gte=1, class_rate__lte=10) |
                    models.Q(class_rate__isnull=True)
                ),
                name='class_rate_in_range'
            ),
            models.CheckConstraint(
                check=(
                    models.Q(teacher_rate__gte=1, teacher_rate__lte=10) |
                    models.Q(teacher_rate__isnull=True)
                ),
                name='teacher_rate_in_range'
            ),
        ]
        