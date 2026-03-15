# SCREEN DETAIL: UCF_01 – Confirm file

> **Mã màn hình:** `SCR-USER-45`  
> **Tên màn hình:** Confirm file (健診データ確認)  
> **Mô tả ngắn:** Màn hình để nhân viên xem, đối chiếu kết quả OCR các chỉ số sức khỏe, chỉnh sửa giá trị sai/thiếu, lọc E-judgement và gửi (submit) bản chính thức.  
> **Ngày tạo:** 2025-10-16  
> **Ngày cập nhật cuối:** 2025-10-16  
> **Phiên bản:** 2.1

---

## Mục lục
- [1. Tổng quan](#1-tổng-quan)
- [2. Chi tiết màn hình](#2-chi-tiết-màn-hình)
- [3. Luồng tương tác](#3-luồng-tương-tác)
- [4. Validation procedures detail](#4-validation-procedures-detail)

---

## 1. Tổng quan

### 1.1 Mục đích
Cho phép **User (nhân viên)** xác nhận dữ liệu sức khỏe đã được OCR trích xuất từ file upload, chỉnh sửa các trường sai/thiếu và **submit** bản chính thức để chuyển cho Industrial Physician đánh giá. Hỗ trợ **lọc E-judgement** để người dùng tập trung vào các giá trị bất thường.

### 1.2 Đối tượng sử dụng màn hình (Role)
- **User (Nhân viên):** View/Edit 64 chỉ số, lọc E-judgement, Upload again, Submit.
- **Các vai trò Admin/IP/HN/BPIC:** *Không truy cập màn hình này ở User site.* (Xem/đánh giá ở Admin site)

---

## 2. Chi tiết màn hình

#### Section 1 – Hiển thị chỉ số & chỉnh sửa
| STT | Tên thành phần | Loại | Bắt buộc | Mặc định | Mô tả | Action |
|---|---|---|---|---|---|---|
| 1 | Screen title | Text | - | “Confirm file” | Tiêu đề màn hình. | — |
| 2 | Back | Button | - | — | Quay về màn Upload file; **xóa danh sách file đã tải**. | Nhấn → điều hướng UUP_01. |
| 3 | OCR Read Items (1/2, 2/2) | List | - | Dữ liệu OCR | Hiển thị tối đa 64 chỉ số; nếu >26 thì tách 2 trang; item không có từ OCR hiển thị rỗng `" "`. | Cuộn xem; bấm Edit ở từng item. |
| 4 | Edit (per item) | Button | - | — | Mở **Edit field**. | Nhấn → hiện ô nhập. |
| 5 | Edit field | Text box | △ | Giá trị hiện tại | Luôn hiển thị **Original value** (giá trị OCR) bên dưới; để trống sẽ **giữ lại Original** khi lưu. Sai định dạng hiển thị lỗi **HCK-003**. | Nhập → Save. (L/H ratio tự tính = LDL/HDL, 2 chữ số thập phân; nếu thiếu LDL/HDL thì để trống). |
| 6 | Save | Button | - | — | Lưu giá trị mới, đóng ô Edit. Nếu để trống → lưu và hoàn nguyên về Original. | Nhấn → lưu nháp tại client/server. |
| 7 | Edited item highlight | Text style | - | — | Mọi item **khác Original** sẽ **tô nền cam** để nhận biết đã chỉnh. | Tự động áp dụng sau Save. |

#### Section 2 – Điều hướng & tác vụ
| STT | Tên thành phần | Loại | Bắt buộc | Mặc định | Mô tả | Action |
|---|---|---|---|---|---|---|
| 8 | Next | Button | - | Ẩn trên trang 2/2 | Chỉ hiển thị trang **1/2**; khi cuộn đến cuối, nút chuyển sang **floating**. | Nhấn → sang trang 2/2 & **clear filter E**. |
| 11 | Previous | Button | - | Ẩn trên trang 1/2 | Chỉ hiển thị trang **2/2**; khi cuộn đến cuối, nút **floating**. | Nhấn → về trang 1/2 & **clear filter E**. |
| 9 | Filter E judgement | Button | - | — | Bật **chế độ lọc E-judgement** cho **chỉ trang đang xem**; hiển thị toast **HCK-022**. | Nhấn → chỉ hiện các item đạt ngưỡng E, **giá trị màu đỏ**. |
| 14 | Stop filter E judgement | Button | - | Ẩn | Chỉ hiển thị khi đang bật lọc E. | Nhấn → trở về **All data** mode. |
| 10 | Upload again | Button | - | — | Mở popup **Discard change** xác nhận bỏ thay đổi & quay lại upload. | Nhấn → mở popup; chọn **Discard** để về UUP_01, **clear file**. |
| 12 | Submit | Button | 〇 | — | Chỉ hiển thị ở **trang 2/2**; khi cuộn cuối trang, chuyển **floating**. | Nhấn → mở popup “Confirm anything else…”. |

#### Section 3 – Popups
| STT | Tên thành phần | Loại | Bắt buộc | Mặc định | Mô tả | Action |
|---|---|---|---|---|---|---|
| 15 | Confirm anything else besides the ones that were read? | Dialog | 〇 | — | Hỏi người dùng có **test items khác** ngoài 60/64 item đã đọc. Bắt buộc chọn **1 trong 2** (Yes/No). | Chọn Yes/No → **Confirm** để tiếp tục hoặc **Cancel** để đóng. |
| 17 | Confirm | Button | 〇 | — | Khi xác nhận từ popup 15. | Mở **Submit successfully**; đồng thời **gửi kết quả đến Industrial Physician (web)**; nếu **không có E-judgement** thì gửi **notification cho user**. |
| 19 | Submit successfully | Dialog | 〇 | — | Thông báo hoàn tất nộp kết quả. | Nhấn **Back to TOP** để về Dashboard. |
| 21 | Discard change | Dialog | 〇 | — | Xác nhận bỏ thay đổi khi “Upload again”. | **Discard** → về Upload & **overwrite** khi upload mới; **Cancel** → đóng. |

---

## 3. Luồng tương tác

### 3.1 Các Bước Thao Tác (dễ hiểu cho non-tech)
1) Từ **Preview** sau upload, hệ thống chạy OCR và đưa tới **Confirm file** để hiển thị tất cả chỉ số.  
2) Người dùng **đối chiếu** với file gốc, **bấm bút chì** để sửa từng mục; lưu xong mục đã sửa sẽ **nền cam**.  
3) Có thể bật **Filter E judgement** để chỉ xem các giá trị bất thường (màu đỏ); filter **chỉ áp dụng trang hiện tại**.  
4) Nếu cần thay file, bấm **Upload again** → **Discard change** → quay lại **Upload** và file mới **ghi đè** file cũ.  
5) Sau khi đủ & hợp lệ 64 chỉ số, bấm **Submit** → trả lời câu hỏi “**Anything else…**” (Yes/No) → **Confirm**. Hệ thống lưu bản nộp, chuyển trạng thái và hiển thị **Submit successfully** (Back to TOP).

### 3.2 Các Màn Hình Liên Quan
- **Trước:** Upload/Preview (SCR-USER-42/43) → OCR loading (44).  
- **Sau:** Survey item (46) nếu có → Completed (47) và/hoặc Dashboard.  
- **Popups:** Confirm anything else…, Submit successfully, Discard change.

---

## 4. Validation procedures detail

### 4.1 Quy tắc chung (màn hình)
- **Không cho Submit** nếu thiếu **2 chỉ số bắt buộc nhập tay** (Sputum test; Hearing by other method) – kiểm tra tổng thể trước khi mở popup Submit.  
- **Client & Server validation** cho từng trường; lưu **bản nháp** và **bản nộp cuối**; lưu **lịch sử thay đổi**.  
- **L/H Ratio** = LDL / HDL, hiển thị **2 chữ số thập phân**; nếu thiếu LDL hoặc HDL → để trống.  
- **Edited item** khác Original → nền cam (highlight).  
- **Filter E judgement** chỉ áp dụng **trang hiện tại**; dừng filter bằng **Stop filter** hoặc khi chuyển trang.

### 4.2 Ràng buộc & Error Codes
- **HCK-001**: Required field (áp dụng cho 2 chỉ số bắt buộc nhập tay khi submit).  
- **HCK-003**: Invalid format (hiển thị tại ô Edit khi nhập sai định dạng).  
- **HCK-022**: Toast khi bật Filter E judgement.

### Field-level Validation (trích các điểm đặc thù trong phạm vi màn hình)
| Field | Rule |
|---|---|
| LDL, HDL | Số thực ≥ 0; nếu cả 2 hợp lệ → tính **L/H Ratio** và hiển thị 2 chữ số thập phân. |
| Các chỉ số numeric khác | Chấp nhận số thực; định dạng theo locale (dấu chấm thập phân); nhập sai → **HCK-003**. |
| 2 chỉ số không OCR hỗ trợ | **Bắt buộc** phải có trước khi submit (HCK-001). |
| E-judgement display | Khi bật filter, chỉ hiển thị các mục đạt ngưỡng E; giá trị màu **đỏ**. |

---

**Ghi chú triển khai:** Màn hình này gắn với luồng User Site; khi **Confirm** thành công, dữ liệu được chuyển đến kênh đánh giá của **Industrial Physician** trên web Admin; đồng thời xử lý thông báo cho user tùy điều kiện E-judgement.

--- 
