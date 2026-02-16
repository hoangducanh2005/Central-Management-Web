from rest_framework import viewsets
from .models import NhanVien, Teacher, HocVien
from .serializers import NhanVienSerializer, TeacherSerializer, HocVienSerializer

class NhanVienViewSet(viewsets.ModelViewSet):
    queryset = NhanVien.objects.all()
    serializer_class = NhanVienSerializer

class TeacherViewSet(viewsets.ModelViewSet):
    queryset = Teacher.objects.all()
    serializer_class = TeacherSerializer

class HocVienViewSet(viewsets.ModelViewSet):
    queryset = HocVien.objects.all()
    serializer_class = HocVienSerializer