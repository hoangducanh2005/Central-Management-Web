# Central-Management-Web

**Project này được phát triển phục vụ cho môn học IT3290 - Thực hành Cơ sở dữ liệu tại  Đại học Bách Khoa Hà Nội (HUST).**

## Giới thiệu
Central-Management-Web là hệ thống quản lý trung tâm toán học, hỗ trợ quản lý học viên, giáo viên, nhân viên, lớp học, loại lớp, lịch học, điểm danh và đánh giá.

## Tính năng nổi bật
- Quản lý học viên, giáo viên, nhân viên, lớp học, loại lớp
- Quản lý lịch học, điểm danh, đánh giá
- Tìm kiếm nhanh theo tên, email, mã, SĐT...
- **Phân trang** đẹp, hiện đại cho tất cả các trang danh sách (học viên, giáo viên, lớp học, nhân viên, loại lớp, điểm danh, đánh giá...)
- Giao diện UI hiện đại, màu sắc chủ đạo xanh, responsive, nhiều hiệu ứng đẹp
- Form nhập liệu có validate, thông báo lỗi rõ ràng, hỗ trợ Select2, datepicker, loading state
- Thống kê, dashboard trực quan

## Hướng dẫn cài đặt & chạy
1. **Cài đặt Python 3.9+**
2. Cài đặt các thư viện:
   ```bash
   pip install -r requirements.txt
   ```
3. **Chạy migrate**:
   ```bash
   python central_management_web/manage.py migrate
   ```
4. **Chạy server**:
   ```bash
   python central_management_web/manage.py runserver
   ```
5. Truy cập: http://127.0.0.1:8000/

## Cấu hình Database

### Sử dụng SQLite (mặc định)
- Không cần cấu hình gì thêm, chỉ cần migrate là chạy được.
- File database sẽ nằm ở: `central_management_web/db.sqlite3`

### Sử dụng PostgreSQL (tuỳ chọn)
1. Cài đặt PostgreSQL và tạo database mới, ví dụ:
   ```sql
   CREATE DATABASE central_management_db;
   CREATE USER central_user WITH PASSWORD 'yourpassword';
   GRANT ALL PRIVILEGES ON DATABASE central_management_db TO central_user;
   ```
2. Cập nhật file `central_management_web/central_management_web/settings.py`:
   ```python
   DATABASES = {
       'default': {
           'ENGINE': 'django.db.backends.postgresql',
           'NAME': 'central_management',
           'USER': 'central_user',
           'PASSWORD': 'yourpassword',
           'HOST': 'localhost',
           'PORT': '5432',
       }
   }
   ```
3.  Import các script SQL nếu cần:
   - `gen_data.sql` ( Để sinh dữ liệu mẫu - Tùy chọn)
   - `TRIGGER_FUNCTION.sql` ( Trigger - Nên import)
