from django.contrib import admin
from .models import nhan_vien, teacher, hoc_vien, clazz, schedule, enrollments, attendance, feedback




@admin.register(nhan_vien)
class NhanVienAdmin(admin.ModelAdmin):
    list_display = ('nv_id', 'full_name', 'gender', 'birth_day', 'email', 'sdt', 'address')
    search_fields = ('nv_id', 'full_name', 'email', 'sdt')
    list_filter = ('gender',)
    ordering = ('nv_id',)

@admin.register(teacher)
class TeacherAdmin(admin.ModelAdmin):
    list_display = ('teacher_id', 'full_name', 'gender', 'birth_day', 'email', 'sdt', 'address')
    search_fields = ('teacher_id', 'full_name', 'email', 'sdt')
    list_filter = ('gender',)
    ordering = ('teacher_id',)

@admin.register(hoc_vien)
class HocVienAdmin(admin.ModelAdmin):
    list_display = ('student_id', 'full_name', 'gender', 'birth_day', 'email', 'sdt', 'address')
    search_fields = ('student_id', 'full_name', 'email', 'sdt')
    list_filter = ('gender',)
    ordering = ('student_id',)

@admin.register(clazz)
class ClassAdmin(admin.ModelAdmin):
    list_display = ('class_id', 'class_name', 'nhan_vien', 'teacher', 'type', 'room', 
                   'khai_giang', 'ket_thuc', 'si_so', 'price')
    search_fields = ('class_id', 'class_name', 'room')
    list_filter = ('type', 'khai_giang', 'ket_thuc')
    ordering = ('class_id',)
    raw_id_fields = ('nhan_vien', 'teacher')

@admin.register(schedule)
class ScheduleAdmin(admin.ModelAdmin):
    list_display = ('id_schedule', 'class_obj', 'days', 'start_time', 'end_time')
    search_fields = ('id_schedule', 'class_obj__class_name', 'days')
    list_filter = ('days',)
    ordering = ('id_schedule',)
    raw_id_fields = ('class_obj',)

@admin.register(enrollments)
class EnrollmentAdmin(admin.ModelAdmin):
    list_display = ('student', 'class_obj', 'enrollment_date', 'minitest1', 'minitest2', 
                   'minitest3', 'minitest4', 'midterm', 'final_test')
    search_fields = ('student__full_name', 'class_obj__class_name')
    list_filter = ('enrollment_date',)
    ordering = ('-enrollment_date',)
    raw_id_fields = ('student', 'class_obj')

@admin.register(attendance)
class AttendanceAdmin(admin.ModelAdmin):
    list_display = ('id_attend', 'student', 'class_obj', 'attendance_date', 'status')
    search_fields = ('id_attend', 'student__full_name', 'class_obj__class_name')
    list_filter = ('status', 'attendance_date')
    ordering = ('-attendance_date',)
    raw_id_fields = ('student', 'class_obj')

@admin.register(feedback)
class FeedBackAdmin(admin.ModelAdmin):
    list_display = ('id_feedback', 'student', 'class_obj', 'teacher', 'class_rate', 'teacher_rate')
    search_fields = ('id_feedback', 'student__full_name', 'class_obj__class_name', 'teacher__full_name')
    list_filter = ('class_rate', 'teacher_rate')
    ordering = ('id_feedback',)
    raw_id_fields = ('student', 'class_obj', 'teacher')
