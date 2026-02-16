from django import forms
from .models import teacher, hoc_vien, clazz, nhan_vien, class_type, schedule
from datetime import datetime, date

class TeacherForm(forms.ModelForm):
    class Meta:
        model = teacher
        fields = ['full_name', 'gender', 'birth_day', 'email', 'sdt', 'address', 'trinh_do']
        widgets = {
            'birth_day': forms.DateInput(attrs={'type': 'date'}),
            'gender': forms.Select(choices=[('M', 'Nam'), ('F', 'Nữ')]),
            'trinh_do': forms.Select(choices=[('Cử nhân', 'Cử nhân'), ('Thạc Sĩ', 'Thạc Sĩ'), ('Tiến Sĩ', 'Tiến Sĩ')])
        }

class HocVienForm(forms.ModelForm):
    class Meta:
        model = hoc_vien
        fields = ['full_name', 'gender', 'birth_day', 'email', 'sdt', 'address']
        widgets = {
            'birth_day': forms.DateInput(attrs={'type': 'date'}),
            'gender': forms.Select(choices=[('M', 'Nam'), ('F', 'Nữ')])
        }

class ClassForm(forms.ModelForm):
    class Meta:
        model = clazz
        fields = ['class_name', 'nhan_vien', 'teacher', 'type', 'room', 'khai_giang', 'ket_thuc', 'price']
        widgets = {
            'nhan_vien': forms.Select(attrs={'class': 'select2'}),
            'teacher': forms.Select(attrs={'class': 'select2'}),
            'khai_giang': forms.DateInput(attrs={'type': 'date', 'placeholder': 'yyyy-mm-dd'}),
            'ket_thuc': forms.DateInput(attrs={'type': 'date', 'placeholder': 'yyyy-mm-dd'})
        }

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.fields['khai_giang'].input_formats = ['%Y-%m-%d']
        self.fields['ket_thuc'].input_formats = ['%Y-%m-%d']

class NhanVienForm(forms.ModelForm):
    class Meta:
        model = nhan_vien
        fields = ['full_name', 'gender', 'birth_day', 'email', 'sdt', 'address']
        widgets = {
            'birth_day': forms.DateInput(attrs={'type': 'date'}),
            'gender': forms.Select(choices=[('M', 'Nam'), ('F', 'Nữ')])
        }

class ClassTypeForm(forms.ModelForm):
    class Meta:
        model = class_type
        fields = ['describe', 'code']

class ScheduleForm(forms.ModelForm):
    days = forms.MultipleChoiceField(
        choices=[
            ('2', 'Thứ 2'),
            ('3', 'Thứ 3'),
            ('4', 'Thứ 4'),
            ('5', 'Thứ 5'),
            ('6', 'Thứ 6'),
            ('7', 'Thứ 7'),
            ('CN', 'Chủ nhật'),
        ],
        widget=forms.CheckboxSelectMultiple(attrs={'class': 'form-check-input'}),
        label="Chọn ngày trong tuần",
        required=True
    )
    class Meta:
        model = schedule
        fields = ['days', 'start_time', 'end_time']
        widgets = {
            'start_time': forms.TimeInput(attrs={
                'type': 'time',
                'class': 'form-control',
                'step': '60',
                'data-time-format': '24',
                'pattern': '[0-9]{2}:[0-9]{2}'
            }),
            'end_time': forms.TimeInput(attrs={
                'type': 'time',
                'class': 'form-control',
                'step': '60',
                'data-time-format': '24',
                'pattern': '[0-9]{2}:[0-9]{2}'
            }),
        }

    def clean_days(self):
        days = self.cleaned_data.get('days')
        if not days:
            raise forms.ValidationError("Vui lòng chọn ít nhất một ngày trong tuần.")
        if len(days) != 3:
            raise forms.ValidationError("Vui lòng chọn đúng 3 ngày trong tuần.")
        return days

    def clean(self):
        cleaned_data = super().clean()
        start_time = cleaned_data.get('start_time')
        end_time = cleaned_data.get('end_time')
        
        if start_time and end_time:
            # Chuyển đổi thành datetime để tính toán
            start_dt = datetime.combine(date.min, start_time)
            end_dt = datetime.combine(date.min, end_time)
            
            # Tính khoảng cách thời gian (giờ)
            delta_hours = (end_dt - start_dt).total_seconds() / 3600
            
            if delta_hours != 2:
                raise forms.ValidationError("Thời gian kết thúc phải cách thời gian bắt đầu đúng 2 tiếng.")
            
            if end_time <= start_time:
                raise forms.ValidationError("Thời gian kết thúc phải sau thời gian bắt đầu.")
        
        return cleaned_data