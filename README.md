# 🧰 Script Linh Tinh – Kho tiện ích nhỏ cho Dev, DevOps và dân vọc vạch

**Repo:** [kiennnd/scripts](https://github.com/kiennnd/scripts)

Chào mừng bạn đến với **Script Linh Tinh**, nơi tập hợp những đoạn mã nhỏ, script tiện ích, công cụ CLI và automation tool tôi sử dụng trong quá trình làm việc: từ phát triển phần mềm, quản trị hệ thống, xử lý dữ liệu đến các công việc vặt vãnh thường ngày.

> Dù “linh tinh” nhưng chúng đều hữu ích, tái sử dụng cao và tiết kiệm thời gian.

---

## 📦 Nội dung repo

Repo này chứa rất nhiều script nhỏ được viết bằng nhiều ngôn ngữ như:

- **Bash** – Quản lý server, dọn dẹp docker, backup, kiểm tra SSL
- **Node.js / TypeScript** – Tạo data mock, chuyển đổi định dạng file, tạo CLI tool
- **Python** – Gọi API hàng loạt, xử lý file, thao tác dữ liệu
- **SQL** – Truy vấn mẫu, tối ưu dữ liệu, backup
- **Docker & Compose** – Cấu hình môi trường test nhanh (Postgres, Redis, MinIO,...)
- **PowerShell** – Tác vụ quản lý hệ thống Windows

Một số ví dụ:

| Script | Mô tả ngắn |
|--------|-----------|
| `cleanup-docker.sh` | Xoá container/image/volume không dùng |
| `api-tester.py` | Gửi nhiều request từ danh sách API |
| `convert-csv-json.js` | Chuyển đổi CSV ↔ JSON |
| `gen-mock.ts` | Sinh dữ liệu giả cho test |
| `check-ssl-expiry.sh` | Kiểm tra chứng chỉ SSL sắp hết hạn |
| `redis-watcher.sh` | Theo dõi thay đổi Redis key theo thời gian thực |

---

## 🔧 Cách sử dụng

1. Clone repo:

```bash
git clone https://github.com/kiennnd/scripts.git
cd scripts