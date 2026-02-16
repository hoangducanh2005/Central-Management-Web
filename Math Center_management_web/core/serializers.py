from rest_framework import serializers
from .models import NhanVien, Teacher, HocVien

class NhanVienSerializer(serializers.ModelSerializer):
    class Meta:
        model = NhanVien
        fields = '__all__'

class TeacherSerializer(serializers.ModelSerializer):
    class Meta:
        model = Teacher
        fields = '__all__'

class HocVienSerializer(serializers.ModelSerializer):
    class Meta:
        model = HocVien
        fields = '__all__'