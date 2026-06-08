# Offline Pharmacy HIS V10 — PWA สำหรับ Cloudflare Pages

แตกไฟล์ ZIP แล้วอัปโหลด **ไฟล์และโฟลเดอร์ทั้งหมดภายใน ZIP** เป็น root ของ Cloudflare Pages

โครงสร้างหลักที่ต้องคงไว้:

```text
/
├── index.html
├── manifest.webmanifest
├── sw.js
├── doctor/
│   └── doctor.html
├── pharmacy/
│   └── pharmacy.html
├── assets/
├── data/
└── templates/
```

URL หลัง deploy:

- หน้าเลือก workflow: `/index.html`
- แพทย์: `/doctor/doctor.html`
- ห้องยา: `/pharmacy/pharmacy.html`

เปิดระบบผ่าน HTTPS ขณะออนไลน์ครั้งแรก เพื่อให้ Service Worker และไฟล์ช่วยเหลือถูกบันทึกสำหรับใช้งานออฟไลน์

พัฒนาโดย ภก.จุมพล อุทธา หัวหน้างานคลังยาและเภสัชสารสนเทศ กลุ่มงานเภสัชกรรม โรงพยาบาลมะเร็งอุบลราชธานี โทร 0897179248
