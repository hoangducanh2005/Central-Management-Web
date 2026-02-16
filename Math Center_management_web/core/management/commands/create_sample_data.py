from django.core.management.base import BaseCommand
from datetime import date, time
from core.models import NhanVien, Teacher, HocVien, Class, Schedule, Enrollment, Attendance, FeedBack

class Command(BaseCommand):
    help = 'Tạo dữ liệu mẫu cho hệ thống'

    def handle(self, *args, **options):
        self.stdout.write("Đang tạo dữ liệu mẫu...")
        
        # Tạo Nhân viên
        nv1, created = NhanVien.objects.get_or_create(
            ma_nv="NV001",
            defaults={
                'full_name': "Nguyễn Văn An",
                'gender': "M",
                'birth_day': date(1985, 5, 15),
                'email': "nva@example.com",
                'sdt': "0901234567",
                'address': "123 Đường ABC, TP.HCM"
            }
        )
        
        nv2, created = NhanVien.objects.get_or_create(
            ma_nv="NV002",
            defaults={
                'full_name': "Trần Thị Bình",
                'gender': "F",
                'birth_day': date(1988, 8, 20),
                'email': "ttb@example.com",
                'sdt': "0907654321",
                'address': "456 Đường XYZ, TP.HCM"
            }
        )
        
        # Tạo Giáo viên
        gv1, created = Teacher.objects.get_or_create(
            teacher_id="GV001",
            defaults={
                'full_name': "Lê Văn Cường",
                'gender': "M",
                'birth_day': date(1980, 3, 10),
                'email': "lvc@example.com",
                'sdt': "0912345678",
                'address': "789 Đường DEF, TP.HCM"
            }
        )
        
        gv2, created = Teacher.objects.get_or_create(
            teacher_id="GV002",
            defaults={
                'full_name': "Phạm Thị Dung",
                'gender': "F",
                'birth_day': date(1982, 7, 25),
                'email': "ptd@example.com",
                'sdt': "0923456789",
                'address': "321 Đường GHI, TP.HCM"
            }
        )
        
        # Tạo Học viên
        hv1, created = HocVien.objects.get_or_create(
            student_id="HV001",
            defaults={
                'full_name': "Hoàng Văn Em",
                'gender': "M",
                'birth_day': date(2000, 1, 15),
                'email': "hve@example.com",
                'sdt': "0934567890",
                'address': "654 Đường JKL, TP.HCM"
            }
        )
        
        hv2, created = HocVien.objects.get_or_create(
            student_id="HV002",
            defaults={
                'full_name': "Vũ Thị Phương",
                'gender': "F",
                'birth_day': date(1999, 12, 5),
                'email': "vtp@example.com",
                'sdt': "0945678901",
                'address': "987 Đường MNO, TP.HCM"
            }
        )
        
        hv3, created = HocVien.objects.get_or_create(
            student_id="HV003",
            defaults={
                'full_name': "Đỗ Văn Giang",
                'gender': "M",
                'birth_day': date(2001, 6, 18),
                'email': "dvg@example.com",
                'sdt': "0956789012",
                'address': "147 Đường PQR, TP.HCM"
            }
        )
        
        # Tạo Lớp học
        lop1, created = Class.objects.get_or_create(
            class_id="LOP001",
            defaults={
                'nhan_vien': nv1,
                'teacher': gv1,
                'class_name': "Lập trình Python cơ bản",
                'class_type': "O",
                'room': "ONLINE",
                'khai_giang_date': date(2024, 1, 15),
                'ket_thuc_date': date(2024, 4, 15),
                'si_so': 30,
                'price': 2000000
            }
        )
        
        lop2, created = Class.objects.get_or_create(
            class_id="LOP002",
            defaults={
                'nhan_vien': nv2,
                'teacher': gv2,
                'class_name': "Web Development với Django",
                'class_type': "F",
                'room': "P101",
                'khai_giang_date': date(2024, 2, 1),
                'ket_thuc_date': date(2024, 5, 1),
                'si_so': 25,
                'price': 3000000
            }
        )
        
        # Tạo Đăng ký học với điểm số mẫu
        dk1, created = Enrollment.objects.get_or_create(
            student=hv1,
            class_obj=lop1,
            defaults={
                'enrollment_date': date(2024, 1, 10),
                'minitest1': 8.5,
                'minitest2': 7.8,
                'minitest3': 9.0,
                'minitest4': 8.2,
                'midterm': 8.0,
                'final': 8.5
            }
        )
        
        dk2, created = Enrollment.objects.get_or_create(
            student=hv2,
            class_obj=lop1,
            defaults={
                'enrollment_date': date(2024, 1, 12),
                'minitest1': 9.0,
                'minitest2': 8.5,
                'minitest3': 8.8,
                'minitest4': 9.2,
                'midterm': 8.8,
                'final': 9.0
            }
        )
        
        self.stdout.write(
            self.style.SUCCESS(
                f'✅ Đã tạo dữ liệu mẫu thành công!\n'
                f'- Nhân viên: {NhanVien.objects.count()}\n'
                f'- Giáo viên: {Teacher.objects.count()}\n'
                f'- Học viên: {HocVien.objects.count()}\n'
                f'- Lớp học: {Class.objects.count()}\n'
                f'- Đăng ký: {Enrollment.objects.count()}'
            )
        ) 