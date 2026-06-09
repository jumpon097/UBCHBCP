# Offline Pharmacy HIS V12 — Cloudflare Pages package

อัปโหลดไฟล์และโฟลเดอร์ **ภายใน ZIP** ทั้งหมดไว้ที่ root ของ GitHub Repository แล้วเชื่อม Repository กับ Cloudflare Pages

## โครงสร้างที่ต้องคงไว้

```
/
├── index.html
├── 404.html
├── _headers
├── _redirects
├── pwsh.sh
├── install-qz-tray.ps1
├── manifest.webmanifest
├── sw.js
├── doctor/
│   ├── index.html
│   └── doctor.html
├── pharmacy/
│   ├── index.html
│   └── pharmacy.html
├── assets/
├── data/
└── templates/
```

## URL หลัง Deploy

- หน้าแรก: `https://<site>.pages.dev/`
- หน้าแพทย์: `https://<site>.pages.dev/doctor/doctor.html`
- หน้าห้องยา: `https://<site>.pages.dev/pharmacy/pharmacy.html`
- ติดตั้ง QZ Tray: เปิด PowerShell แบบ Run as Administrator แล้วรัน `irm "https://<site>.pages.dev/pwsh.sh" | iex`

## ค่า Cloudflare Pages

- Framework preset: `None`
- Build command: เว้นว่าง หรือ `exit 0`
- Build output directory: `.`
- Root directory: เว้นว่าง เมื่อไฟล์อยู่ที่ root ของ Repository

## หมายเหตุ

- `pwsh.sh` เป็น PowerShell script แม้ใช้นามสกุล `.sh` เพื่อให้คำสั่งติดตั้งสั้นตามรูปแบบ `irm ... | iex`
- สคริปต์เรียก GitHub API ของ Repository ทางการ `qzind/tray` และเปิด Windows installer จาก official release
- เปิดหน้าแพทย์และหน้าห้องยาออนไลน์อย่างน้อย 1 ครั้งก่อนทดสอบ Offline

พัฒนาโดย ภก.จุมพล อุทธา หัวหน้างานคลังยาและเภสัชสารสนเทศ กลุ่มงานเภสัชกรรม โรงพยาบาลมะเร็งอุบลราชธานี โทร 0897179248
