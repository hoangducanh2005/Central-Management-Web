from django.urls import path
from . import views
from django.contrib.auth import views as auth_views

app_name = 'core'

urlpatterns = [
    # Trang chủ
    path('', views.home, name='home'),
    
    # Authentication
    path('login/', views.login_view, name='login'),
    path('logout/', views.logout_view, name='logout'),

    # Dashboard (có thể truy cập bằng cả / và /dashboard/)
    path('dashboard/', views.admin_dashboard, name='admin_dashboard'),

    # Statistics
    #path('statistics/', views.statistics, name='statistics'),


    # Student Management
    path('students/', views.student_list, name='student_list'),
    path('students/create/', views.student_create, name='student_create'),
    path('students/<str:pk>/edit/', views.student_edit, name='student_edit'),
    path('students/<str:pk>/delete/', views.student_delete, name='student_delete'),

    # Teacher Management
    path('teachers/', views.teacher_list, name='teacher_list'),
    path('teachers/create/', views.teacher_create, name='teacher_create'),
    path('teachers/<int:pk>/edit/', views.teacher_edit, name='teacher_edit'),
    path('teachers/<int:pk>/delete/', views.teacher_delete, name='teacher_delete'),

    # Nhan Vien Management
    path('nhanvien/', views.nhanvien_list, name='nhanvien_list'),
    path('nhanvien/create/', views.nhanvien_create, name='nhanvien_create'),
    path('nhanvien/<int:pk>/edit/', views.nhanvien_edit, name='nhanvien_edit'),
    path('nhanvien/<int:pk>/delete/', views.nhanvien_delete, name='nhanvien_delete'),

    # Class Management
    path('classes/', views.class_list, name='class_list'),
    path('classes/create/', views.class_create, name='class_create'),
    path('classes/<str:pk>/', views.class_detail, name='class_detail'),
    path('classes/<str:pk>/edit/', views.class_edit, name='class_edit'),
    path('classes/<str:pk>/delete/', views.class_delete, name='class_delete'),

    # Schedule Management
    path('schedules/', views.schedule_list, name='schedule_list'),
    path('schedules/create/', views.schedule_create, name='schedule_create'),
    path('schedules/<int:pk>/edit/', views.schedule_edit, name='schedule_edit'),
    path('schedules/<int:pk>/delete/', views.schedule_delete, name='schedule_delete'),

    # Attendance Management
    path('attendance/', views.attendance_list, name='attendance_list'),
    path('attendance/create/', views.attendance_create, name='attendance_create'),
    path('attendance/<int:pk>/edit/', views.attendance_edit, name='attendance_edit'),
    path('attendance/<int:pk>/delete/', views.attendance_delete, name='attendance_delete'),

    # Feedback Management
    path('feedback/', views.feedback_list, name='feedback_list'),
    path('feedback/create/', views.feedback_create, name='feedback_create'),
    path('feedback/import/', views.feedback_import, name='feedback_import'),
    path('feedback/<int:pk>/view/', views.feedback_view, name='feedback_detail'),
    path('feedback/<int:pk>/delete/', views.feedback_delete, name='feedback_delete'),

    # Class Type Management
    path('class-types/', views.class_type_list, name='class_type_list'),
    path('class-types/create/', views.class_type_create, name='class_type_create'),
    path('class-types/<int:pk>/edit/', views.class_type_edit, name='class_type_edit'),
    path('class-types/<int:pk>/delete/', views.class_type_delete, name='class_type_delete'),
]