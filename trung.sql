-- create database

CREATE Database hackthon;
use hackthon;
-- Bài 2.
-- Hiển thị toàn bộ nội dung của bảng architect
SELECT * FROM `architect`;
-- Hiển thị danh sách gồm họ tên và giới tính của kiến trúc sư
SELECT name,sex FROM `architect`;
-- Hiển thị những năm sinh có thể có của các kiến trúc sư
SELECT birthday FROM `architect`;
-- Hiển thị danh sách các kiến trúc sư (họ tên và năm sinh) (giá trị năm sinh tăng dần)
SELECT name,birthday FROM `architect` ORDER BY birthday ASC;
-- Hiển thị danh sách các kiến trúc sư (họ tên và năm sinh) (giá trị năm sinh giảm dần)
SELECT name,birthday FROM `architect` ORDER BY birthday DESC;
-- Hiển thị danh sách các công trình có chi phí từ thấp đến cao. Nếu 2 công trình có chi phí bằng nhau sắp xếp tên thành phố theo bảng chữ cái building
SELECT name, cost FROM building ORDER BY cost ASC, name ASC;
-- Bai 4.
-- Hiển thị tất cả thông tin của kiến trúc sư "le thanh tung"
SELECT * FROM `architect` WHERE name= 'le thanh tung';
-- Hiển thị tên, năm sinh các công nhân có chuyên môn hàn hoặc điện
SELECT name,birthday FROM `worker` WHERE skill IN ('han', 'dien');
-- Hiển thị tên các công nhân có chuyên môn hàn hoặc điện và năm sinh lớn hơn 1948
SELECT name, birthday FROM worker WHERE (skill = 'han' OR skill = 'dien') AND birthday > 1948;
-- Hiển thị những công nhân bắt đầu vào nghề khi dưới 20 (birthday + 20 > year)
SELECT * FROM `worker` WHERE (`birthday` + 20) > `year`; 
-- Hiển thị những công nhân có năm sinh 1945, 1940, 1948
SELECT name, birthday FROM worker WHERE `birthday` IN (1945, 1940, 1948);
-- Tìm những công trình có chi phí đầu tư từ 200 đến 500 triệu đồng
SELECT * FROM building WHERE cost >= 200 AND cost <= 500;
-- Tìm kiếm những kiến trúc sư có họ là nguyen: % chuỗi
SELECT * FROM architect WHERE name LIKE 'Nguyen%' OR name = 'Nguyen';

-- Tìm kiếm những kiến trúc sư có tên đệm là anh
SELECT * FROM architect WHERE name LIKE '% Anh %' OR name LIKE 'Anh %' OR name LIKE '% Anh';
-- Tìm kiếm những kiến trúc sư có tên bắt đầu th và có 3 ký tự
SELECT * FROM architect WHERE name LIKE '%th_';
-- Tìm chủ thầu không có phone
SELECT * FROM contractor WHERE phone IS NULL;

-- bài 5
-- Thống kê tổng số kiến trúc sư
SELECT COUNT(*) AS TongSoKienTrucSu FROM architect;
-- Tìm ngày tham gia công trình nhiều nhất của công nhân
SELECT worker_id, MAX(total) AS NgayThamGiaCongTrinh FROM work GROUP BY worker_id;
-- Tìm ngày tham gia công trình ít nhất của công nhân SELECT worker_id, MIN(total) AS NgayThamGiaCongTrinh FROM work GROUP BY worker_id;
SELECT worker_id, MIN(total) AS NgayThamGiaCongTrinh FROM work GROUP BY worker_id;
-- Tìm tổng số ngày tham gia công trình của tất cả công nhân
SELECT `date`
FROM `work`
WHERE `worker_id` = (SELECT `worker_id` FROM `work` GROUP BY `worker_id` ORDER BY COUNT(*) ASC LIMIT 1)
ORDER BY `date` ASC
LIMIT 1;    
-- Tìm tổng số ngày tham gia công trình của tất cả công nhân 
SELECT SUM(`total`) AS total_days
FROM `work`;
-- Tìm tổng chi phí phải trả cho việc thiết kế công trình của kiến trúc sư có Mã số 1
SELECT SUM(`benefit`) AS total_benefit
FROM `design`
WHERE `architect_id` = 1;
-- Tìm trung bình số ngày tham gia công trình của công nhân
SELECT AVG(`total`) AS average_days
FROM `work`;
-- Hiển thị thông tin kiến trúc sư: họ tên, tuổi 
SELECT `name`, YEAR(CURDATE()) - `birthday` AS age
FROM `architect`;
-- Tính thù lao của kiến trúc sư: Thù lao = benefit * 1000
SELECT `architect`.`name`, `design`.`benefit`, `design`.`benefit` * 1000 AS thulao
FROM `design`
JOIN `architect` ON `design`.`architect_id` = `architect`.`id`;
-- Hiển thị thông tin công trình có chi phí cao nhất
SELECT *
FROM `building`
ORDER BY `cost` DESC
LIMIT 1;
-- Hiển thị thông tin công trình có chi phí lớn hơn tất cả các công trình được xây dựng ở Cần Thơ 
SELECT *
FROM `building`
WHERE `city` = 'can tho' AND `cost` > (SELECT MAX(`cost`) FROM `building` WHERE `city` = 'can tho');
-- Hiển thị thông tin công trình có chi phí lớn hơn một trong các công trình được xây dựng ở Cần Thơ 
SELECT *
FROM `building`
WHERE `cost` > ANY (SELECT `cost` FROM `building` WHERE `city` = 'can tho');
-- Hiển thị thông tin công trình chưa có kiến trúc sư thiết kế
SELECT `building`.*
FROM `building`
LEFT JOIN `design` ON `building`.`id` = `design`.`building_id`
WHERE `design`.`architect_id` IS NULL;
-- Hiển thị thông tin các kiến trúc sư cùng năm sinh và cùng nơi tốt nghiệp
SELECT A1.*
FROM `architect` AS A1
JOIN `architect` AS A2 ON A1.`id` <> A2.`id`
WHERE A1.`birthday` = A2.`birthday` AND A1.`place` = A2.`place`;
-- Hiển thị thù lao trung bình của từng kiến trúc sư
SELECT `architect_id`, AVG(`benefit`) AS average_benefit
FROM `design`
GROUP BY `architect_id`;
-- Hiển thị chi phí đầu tư cho các công trình ở mỗi thành phố 
SELECT `city`, SUM(`cost`) AS total_cost
FROM `building`
GROUP BY `city`;
-- Tìm các công trình có chi phí trả cho kiến trúc sư lớn hơn 50 
SELECT *
FROM `design`
WHERE `benefit` > 50;
-- Tìm các thành phố có ít nhất một kiến trúc sư tốt nghiệp
SELECT DISTINCT `place`
FROM `architect`
WHERE `name` LIKE '%tốt nghiệp%';