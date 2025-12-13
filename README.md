Notes App

A new Flutter project.
# Thông tin sinh viên
- **Họ và tên**: Nguyễn Văn Quang
- **MSSV**: 2221050563
- **Lớp**: DCCTCLC67B

## Giới thiệu
Ứng dụng **Note App (Quản lý Ghi chú)** là sản phẩm của bài tập lớn học phần Phát triển ứng dụng di động đa nền tảng 1. Ứng dụng cho phép người dùng lưu trữ các ý tưởng, công việc cá nhân thông qua kết nối mạng với máy chủ cơ sở dữ liệu.

Dự án áp dụng kiến trúc **MVVM (sử dụng Provider)**, kết nối với Backend tự xây dựng bằng **PHP & MySQL**, đảm bảo quy trình kiểm thử tự động và tích hợp liên tục (CI/CD) qua GitHub Actions.

## Mục tiêu đạt được
- [x] Xây dựng giao diện UI/UX thân thiện với Material Design .
- [x] Quản lý trạng thái hiệu quả bằng thư viện `provider`,flutter_test,flutter_lints,cupertino_icons..
- [x] giả lập backend nhanh chóng và hiệu quả cho việc phát triển ứng dụng mà không cần phải triển khai server thực tế..
- [x] Thực hiện trọn vẹn thao tác CRUD (Thêm, Xem, Sửa, Xóa).
- [x] Chức năng nâng cao: **Tìm kiếm (Search) & Sắp xếp (Sort),chỉnh sửa giao diện ,thêm màu cho ghi chú ** dữ liệu realtime.
- [x] Viết Unit Test và Widget Test đảm bảo chất lượng mã nguồn.
- [x] Cấu hình GitHub Actions để tự động Build và Test.

## Giới thiệu dự án:

Mục tiêu của ứng dụng ghi chú:
Ứng dụng ghi chú này được thiết kế để giúp người dùng tạo, lưu trữ và quản lý các ghi chú cá nhân một cách dễ dàng và tiện lợi. Người dùng có thể thêm mới ghi chú, chỉnh sửa, xoá và đánh dấu ghi chú đã hoàn thành.

Ứng dụng còn hỗ trợ tính năng tìm kiếm ghi chú theo tiêu đề hoặc nội dung và sắp xếp ghi chú theo trạng thái (hoàn thành hoặc chưa hoàn thành).

## Các tính năng chính:

**CRUD ghi chú: Tạo mới, chỉnh sửa, xóa và hiển thị các ghi chú.**

**Tìm kiếm ghi chú: Cho phép tìm kiếm ghi chú theo tiêu đề hoặc nội dung.**

**Quản lý trạng thái: Có thể đánh dấu ghi chú là hoàn thành hoặc chưa hoàn thành.**

**Giao diện người dùng thân thiện: Giao diện sử dụng Material Design với chế độ sáng và tối.**

**Lưu trữ dữ liệu trên MockAPI: Dữ liệu ghi chú được lưu trữ trên MockAPI, hỗ trợ các thao tác CRUD và đồng bộ dữ liệu khi có thay đổi.**

**MockAPI: Giải pháp phát triển ứng dụng nhanh chóng**

MockAPI là công cụ miễn phí giúp bạn mô phỏng một API RESTful mà không cần phải triển khai backend thực tế. Bạn có thể thực hiện các thao tác CRUD (Create, Read, Update, Delete) trên dữ liệu ghi chú của mình mà không cần lo lắng về việc cài đặt hoặc bảo trì server.

Lợi ích khi sử dụng MockAPI:

Tiết kiệm thời gian phát triển: Bạn không phải thiết lập backend thực tế, giúp bạn bắt tay vào phát triển ứng dụng nhanh chóng.

Quản lý dữ liệu dễ dàng: MockAPI cung cấp giao diện người dùng đơn giản để tạo và quản lý dữ liệu mà không cần phải viết mã.

Không cần server: Bạn không phải lo lắng về việc duy trì các server thực tế, mà vẫn có thể thực hiện đầy đủ các thao tác CRUD.

Thử nghiệm linh hoạt: MockAPI cho phép bạn thử nghiệm nhanh chóng và thay đổi cấu trúc dữ liệu mà không cần cập nhật lại backend.

Quản lý nhiều bảng dữ liệu: Bạn có thể tạo nhiều bảng dữ liệu (ví dụ: ghi chú, người dùng, thông báo) để mô phỏng các cơ sở dữ liệu thực tế.

Tại sao chọn MockAPI thay vì Firebase hoặc MySQL?

MockAPI là giải pháp lý tưởng khi bạn không muốn mất thời gian và công sức vào việc triển khai backend thực tế. Nó dễ sử dụng, giúp bạn thử nghiệm ứng dụng nhanh chóng, và không đòi hỏi phải duy trì bất kỳ server thực tế nào.
### b. Chức năng Nâng cao
*Tìm kiếm (Real-time Search):** - Xử lý lọc dữ liệu ngay tại Client (phía ứng dụng) giúp phản hồi tức thì khi người dùng gõ phím.
    - Tìm kiếm đa năng trên cả Tiêu đề và Nội dung.
- **Sắp xếp (Sorting):**
    - Hỗ trợ sắp xếp danh sách theo Tên (A-Z) và (Z-A).
    - Sử dụng thuật toán `List.sort` tối ưu của Dart.
    **thay đổi giao diện:** 
      -Hỗ thay đổi giao diện từ sáng thành tối ngược lại.
      -Hỗ thay đổi màu của ghi chú 
Các bước phát triển:

**Khởi tạo dự án Flutter: Tôi đã tạo một dự án Flutter mới sử dụng các thư viện như provider để quản lý trạng thái, http để kết nối với MockAPI và thực hiện các thao tác CRUD.**

**Tích hợp MockAPI: Thay vì Firebase hoặc MySQL, tôi đã kết nối ứng dụng với MockAPI để thực hiện các thao tác CRUD trên dữ liệu ghi chú.**

**Viết unit test: Các bài test được viết để đảm bảo các thao tác CRUD hoạt động chính xác với MockAPI.**

**CI/CD với GitHub Actions: Tôi đã cấu hình GitHub Actions để tự động chạy các bài test khi có thay đổi trong mã nguồn.**

Các công cụ sử dụng:

**Flutter: Framework để xây dựng ứng dụng.**

**MockAPI: Công cụ mô phỏng API để lưu trữ và quản lý dữ liệu ghi chú.**

**GitHub Actions: Tự động hóa quy trình kiểm tra và triển khai ứng dụng.**

**CI/CD với GitHub Actions:**

**GitHub Actions giúp tự động hóa quy trình kiểm tra ứng dụng khi có thay đổi trong mã nguồn. Workflow bao gồm các bước như:**

Cài đặt môi trường Flutter.

Cài đặt dependencies.

Chạy các bài test Flutter để đảm bảo ứng dụng hoạt động như mong đợi.

Lý do chọn giải pháp:

Flutter: Framework phát triển đa nền tảng giúp tiết kiệm thời gian khi phát triển ứng dụng cho cả Android và iOS.

MockAPI: Giải pháp giả lập backend nhanh chóng và hiệu quả cho việc phát triển ứng dụng mà không cần phải triển khai server thực tế.

Provider: Quản lý trạng thái trong ứng dụng, giúp dữ liệu và các thay đổi được đồng bộ một cách hiệu quả.
## 2. Kiểm thử (Testing Strategy)
**fake_note_api_service.dart:**

Chức năng: Tệp này có thể chứa các hàm giả lập hoặc mô phỏng API cho việc kiểm thử. Vì bạn đang sử dụng MockAPI, tệp này có thể tạo một dịch vụ giả lập cho MockAPI để thực hiện các thao tác CRUD mà không cần phải kết nối thật sự với một API bên ngoài.

Mục đích: Mục đích là để kiểm thử các chức năng của ứng dụng mà không phải thực hiện các cuộc gọi thật sự đến API. Điều này giúp giảm thiểu sự phụ thuộc vào mạng và giúp kiểm tra tính đúng đắn của logic.

**note_list_screen_test.dart:**

Chức năng: Đây là tệp kiểm thử cho màn hình danh sách ghi chú (Note List Screen). Các bài kiểm thử ở đây sẽ kiểm tra sự hiển thị danh sách ghi chú, các chức năng như tạo, sửa, xóa ghi chú từ màn hình.

Mục đích: Đảm bảo giao diện người dùng và các tương tác trong màn hình danh sách ghi chú hoạt động chính xác.

**note_model_test.dart:**

Chức năng: Tệp này kiểm thử mô hình dữ liệu Note. Các bài kiểm thử sẽ kiểm tra các phương thức của mô hình này, như tạo đối tượng ghi chú từ JSON hoặc chuyển đổi đối tượng ghi chú thành JSON.

Mục đích: Đảm bảo rằng mô hình Note hoạt động chính xác và các phương thức như fromJson, toJson, v.v., trả về kết quả chính xác.

**note_provider_test.dart:**

Chức năng: Tệp này kiểm thử NoteProvider. NoteProvider là lớp quản lý trạng thái và kết nối với API (MockAPI trong trường hợp của bạn). Các bài kiểm thử sẽ kiểm tra các phương thức trong provider này, như tải dữ liệu ghi chú, tạo, sửa, xóa ghi chú thông qua MockAPI.

Mục đích: Đảm bảo Provider hoạt động đúng, bao gồm việc gọi API, quản lý trạng thái ứng dụng và phản hồi đúng khi có thay đổi.
## 3. Kết quả Tự đánh giá

| Tiêu chí | Mức độ hoàn thành | Điểm tự chấm |
| :--- | :--- | :--- |
| Build thành công | [X] GitHub Actions báo Success, không lỗi build. | **5/5** |
| CRUD cơ bản | [X] Hoàn thiện Thêm/Sửa/Xóa với MySQL. | **+1** |
| Quản lý trạng thái | [X] Sử dụng Provider, code tách biệt rõ ràng. | **+1** |
| Tích hợp API/CSDL | [X] Tự viết API PHP, xử lý lỗi mạng tốt. | **+1** |
| Kiểm thử tự động | [X] Có đầy đủ Unit Test & Widget Test. | **+1** |
| **Nâng cao & CI/CD** | [X] **Tìm kiếm, Sắp xếp, Code sạch, CI/CD hoàn thiện.** | **+0.5 (Max)** |

**=> TỔNG ĐIỂM: 9.5/10**

### Tự đánh giá: 9.5/10
