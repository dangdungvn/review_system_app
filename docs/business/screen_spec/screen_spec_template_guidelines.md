# Screen Detail Documentation Guidelines

Tài liệu hướng dẫn xây dựng mô tả chi tiết cho từng màn hình trong hệ thống. Tài liệu này tập trung vào mô tả giao diện, chức năng, business logic và luồng tương tác từ góc độ người dùng.

---

# 1. Quy Tắc Tổng Quát

- Mỗi màn hình cần có một tài liệu mô tả chi tiết riêng
- Tập trung vào mô tả từ góc độ người dùng, tránh các thuật ngữ kỹ thuật
- Sử dụng ngôn ngữ đơn giản, dễ hiểu

---

# 2. Cấu Trúc Tài Liệu Screen Detail

```markdown
## 1. Tổng Quan

### 1.1 Mục Đích
Mô tả ngắn gọn mục đích sử dụng của màn hình này trong hệ thống.

### 1.2 Đối Tượng Sử Dụng
Liệt kê các vai trò người dùng có thể truy cập màn hình này và quyền thao tác. Ví dụ: End-user (view/edit), Admin (full), Auditor (read-only)…


## 2.Chi tiết màn hình

> **Lưu ý:** Nội dung liên quan đến *kiểu dữ liệu/ký tự/định dạng* sẽ được ghi rõ trong cột **Mô tả** (bao gồm: kiểu dữ liệu, độ dài ký tự, định dạng/regex/mask, ví dụ, placeholder, hint, error message, mô tả chi tiết).  
> **Common Header/Footer**: chỉ cần mô tả tại **một màn hình**; nếu đã có, **note link/tên file screen detail** để tránh trùng lặp.
Mỗi section nên tương ứng với một nhóm logic giao diện (ví dụ: Thông tin cơ bản, Hành động, Xác nhận, ...)
Cấu trúc mỗi section:

#### Section [N] – [Tên section]:

| STT | Tên thành phần | Loại | Bắt buộc |  Mặc định | Mô tả | Action|
| --- | -------------- | ---- | -------- |  -------- | ----- | ----- |
|     |                |      |          |           |       |       |

> **Lưu ý khi mô tả từng thành phần chi tiết**
> **Đối với cột Action:** Mô tả chi tiết các action user sẽ thực hiện đối với từng item
> - Thêm mới
> - Xem chi tiết
> - Cập nhật
> - Xóa
> - Tìm kiếm
> - Lọc
> - Sắp xếp
> **Các Trường Hợp Đặc Biệt**: Mô tả thêm trong cột mô tả
> Mô tả các trường hợp đặc biệt cần xử lý:
> - Điều kiện hiển thị
> - Giới hạn quyền
> - Các thông báo lỗi
> - Các trường hợp ngoại lệ

## 3. Luồng Tương Tác

### 3.1 Các Bước Thao Tác
Mô tả chi tiết các bước thao tác trên màn hình:
1. Bước 1: Mô tả hành động
2. Bước 2: Mô tả hành động
3. Bước 3: Mô tả hành động

### 3.2 Các Màn Hình Liên Quan
Liệt kê các màn hình có liên quan:
- Màn hình trước đó
- Màn hình tiếp theo
- Các popup/dialog

## 4. Validation procedures detail
*(Mô tả thành dạng bảng toàn bộ nghiệp vụ)*

### 4.1 Các Quy Tắc Chung
Liệt kê các quy tắc nghiệp vụ áp dụng cho màn hình:
- Quy tắc về quyền truy cập
- Quy tắc về dữ liệu
- Quy tắc về quy trình

### 4.2 Các Ràng Buộc
Mô tả các ràng buộc cần tuân thủ:
- Ràng buộc về dữ liệu
- Ràng buộc về quy trình
- Ràng buộc về thời gian

### HCK Error Codes:

* `HCK-001`: Required field
* `HCK-003`: Invalid email
* ...

### Field-level Validation:

| Field          | Rule                     |
| -------------- | ------------------------ |
| Tên người dùng | Required, max 100 ký tự  |
| Email          | Required, format, unique |
| ...            | ...                      |

```
