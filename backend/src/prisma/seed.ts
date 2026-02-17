import { RoleName } from "@prisma/client";
import prisma from "../config/prisma";

async function main() {
  console.log("🌱 Starting seed...");

  // =========================================
  // 1. SEED ROLES
  // =========================================
  console.log("📝 Seeding Roles...");

  const adminRole = await prisma.role.upsert({
    where: { name: RoleName.ADMIN },
    update: { name: RoleName.ADMIN },
    create: { name: RoleName.ADMIN },
  });

  const operatorRole = await prisma.role.upsert({
    where: { name: RoleName.OPERATOR },
    update: { name: RoleName.OPERATOR },
    create: { name: RoleName.OPERATOR },
  });

  const kepsekRole = await prisma.role.upsert({
    where: { name: RoleName.KEPSEK },
    update: { name: RoleName.KEPSEK },
    create: { name: RoleName.KEPSEK },
  });

  const guruRole = await prisma.role.upsert({
    where: { name: RoleName.GURU },
    update: { name: RoleName.GURU },
    create: { name: RoleName.GURU },
  });

  console.log("✅ Roles seeded successfully");

  // =========================================
  // 2. SEED SCHOOL
  // =========================================
  console.log("🏫 Seeding School...");

  const school = await prisma.school.upsert({
    where: { name: "SMA Negeri 1 Makassar" },
    update: {
      name: "SMA Negeri 1 Makassar",
      address: "Jl. Adhyaksa No.2, Panakkukang, Makassar",
      phone: "0411-440065",
      email: "info@sman1makassar.sch.id",
    },
    create: {
      name: "SMA Negeri 1 Makassar",
      address: "Jl. Adhyaksa No.2, Panakkukang, Makassar",
      phone: "0411-440065",
      email: "info@sman1makassar.sch.id",
    },
  });

  console.log("✅ School seeded:", school.name);

  // =========================================
  // 3. SEED ALLOWED EMAILS
  // =========================================
  console.log("📧 Seeding Allowed Emails...");

  const allowedEmails = [
    // ============ ADMIN ============
    {
      email: "knabilhakin@gmail.com",
      roleId: adminRole.id,
      description: "Super Admin - Full System Access",
    },
    {
      email: "admin.tech@gmail.com",
      roleId: adminRole.id,
      description: "IT Administrator",
    },

    // ============ OPERATOR ============
    {
      email: "operator.sman1@gmail.com",
      roleId: operatorRole.id,
      description: "Operator TU - Data Entry",
    },
    {
      email: "operator.tata.usaha@gmail.com",
      roleId: operatorRole.id,
      description: "Operator Tata Usaha",
    },
    {
      email: "operator.kesiswaan@gmail.com",
      roleId: operatorRole.id,
      description: "Operator Kesiswaan",
    },

    // ============ KEPSEK ============
    // Note: Kepsek bisa jadi juga seorang Guru
    {
      email: "kepala.sekolah@gmail.com",
      roleId: kepsekRole.id,
      description: "Kepala Sekolah - Dr. Ahmad Dahlan, M.Pd",
    },
    {
      email: "wakasek.kurikulum@gmail.com",
      roleId: kepsekRole.id,
      description: "Wakil Kepala Sekolah Bidang Kurikulum",
    },
    {
      email: "wakasek.kesiswaan@gmail.com",
      roleId: kepsekRole.id,
      description: "Wakil Kepala Sekolah Bidang Kesiswaan",
    },

    // ============ GURU ============
    {
      email: "nh65.nakim.hime@gmail.com",
      roleId: guruRole.id,
      description: "Guru Dummy",
    },
    {
      email: "guru.matematika@gmail.com",
      roleId: guruRole.id,
      description: "Guru Matematika - Budi Santoso, S.Pd",
    },
    {
      email: "guru.fisika@gmail.com",
      roleId: guruRole.id,
      description: "Guru Fisika - Siti Nurhaliza, S.Pd",
    },
    {
      email: "guru.kimia@gmail.com",
      roleId: guruRole.id,
      description: "Guru Kimia - Andi Wijaya, S.Si",
    },
    {
      email: "guru.biologi@gmail.com",
      roleId: guruRole.id,
      description: "Guru Biologi - Dewi Sartika, S.Pd",
    },
    {
      email: "guru.bahasa.indonesia@gmail.com",
      roleId: guruRole.id,
      description: "Guru Bahasa Indonesia - Rahman Hakim, S.Pd",
    },
    {
      email: "guru.bahasa.inggris@gmail.com",
      roleId: guruRole.id,
      description: "Guru Bahasa Inggris - Lisa Anderson, S.Pd",
    },
    {
      email: "guru.sejarah@gmail.com",
      roleId: guruRole.id,
      description: "Guru Sejarah - Hendra Kusuma, S.Pd",
    },
    {
      email: "guru.geografi@gmail.com",
      roleId: guruRole.id,
      description: "Guru Geografi - Nina Marlina, S.Pd",
    },
    {
      email: "guru.ekonomi@gmail.com",
      roleId: guruRole.id,
      description: "Guru Ekonomi - Rizal Mahmud, S.E",
    },
    {
      email: "guru.sosiologi@gmail.com",
      roleId: guruRole.id,
      description: "Guru Sosiologi - Ratna Sari, S.Sos",
    },
    {
      email: "guru.pjok@gmail.com",
      roleId: guruRole.id,
      description: "Guru PJOK - Agus Salim, S.Pd",
    },
    {
      email: "guru.seni.budaya@gmail.com",
      roleId: guruRole.id,
      description: "Guru Seni Budaya - Ayu Lestari, S.Pd",
    },
    {
      email: "guru.pkn@gmail.com",
      roleId: guruRole.id,
      description: "Guru PKN - Bambang Sutejo, S.Pd",
    },
    {
      email: "guru.pai@gmail.com",
      roleId: guruRole.id,
      description: "Guru PAI - Ustadz Abdul Malik, S.Ag",
    },
    {
      email: "guru.informatika@gmail.com",
      roleId: guruRole.id,
      description: "Guru Informatika - Rudi Hartono, S.Kom",
    },

    // ============ GURU yang juga KEPSEK ============
    // Contoh: Kepala Sekolah yang masih mengajar
    {
      email: "kepsek.mengajar@gmail.com",
      roleId: kepsekRole.id, // Primary role: KEPSEK
      description: "Kepala Sekolah yang masih mengajar Matematika",
      // Note: Setelah login pertama kali, user ini akan diberi role GURU juga
    },
  ];

  for (const emailData of allowedEmails) {
    const user = await prisma.user.upsert({
      where: { email: emailData.email },
      update: {
        schoolId: school.id,
        name: emailData.description,
        email: emailData.email,
      },
      create: {
        schoolId: school.id,
        name: emailData.description,
        email: emailData.email,
      },
    });

    await prisma.userRole.upsert({
      where: {
        userId_roleId: {
          userId: user.id,
          roleId: emailData.roleId,
        },
      },
      update: {
        userId: user.id,
        roleId: emailData.roleId,
      },
      create: {
        userId: user.id,
        roleId: emailData.roleId,
      },
    });

    await prisma.allowedEmail.upsert({
      where: {
        schoolId_email: {
          schoolId: school.id,
          email: emailData.email,
        },
      },
      update: {
        schoolId: school.id,
        email: emailData.email,
        roleId: emailData.roleId,
        userId: user.id,
      },
      create: {
        schoolId: school.id,
        email: emailData.email,
        roleId: emailData.roleId,
        userId: user.id,
      },
    });
    console.log(`  ✉️  ${emailData.email} -> ${emailData.description}`);
  }

  console.log("✅ Allowed Emails seeded successfully");

  // =========================================
  // 4. SEED ACADEMIC YEAR & SEMESTER
  // =========================================
  console.log("📅 Seeding Academic Year & Semester...");

  const academicYear = await prisma.academicYear.upsert({
    where: {
      schoolId_name: {
        schoolId: school.id,
        name: "2024/2025",
      },
    },
    update: {
      schoolId: school.id,
      name: "2024/2025",
      startDate: new Date("2024-07-15"),
      endDate: new Date("2025-06-30"),
      isActive: true,
    },
    create: {
      schoolId: school.id,
      name: "2024/2025",
      startDate: new Date("2024-07-15"),
      endDate: new Date("2025-06-30"),
      isActive: true,
    },
  });

  const semesterGanjil = await prisma.semester.upsert({
    where: {
      academicYearId_type: {
        academicYearId: academicYear.id,
        type: "ODD",
      },
    },
    update: {
      academicYearId: academicYear.id,
      type: "ODD",
      startDate: new Date("2024-07-15"),
      endDate: new Date("2024-12-31"),
      isActive: false,
    },
    create: {
      academicYearId: academicYear.id,
      type: "ODD",
      startDate: new Date("2024-07-15"),
      endDate: new Date("2024-12-31"),
      isActive: false,
    },
  });

  const semesterGenap = await prisma.semester.upsert({
    where: {
      academicYearId_type: {
        academicYearId: academicYear.id,
        type: "EVEN",
      },
    },
    update: {
      academicYearId: academicYear.id,
      type: "EVEN",
      startDate: new Date("2025-01-01"),
      endDate: new Date("2025-06-30"),
      isActive: true,
    },
    create: {
      academicYearId: academicYear.id,
      type: "EVEN",
      startDate: new Date("2025-01-01"),
      endDate: new Date("2025-06-30"),
      isActive: true,
    },
  });

  console.log("✅ Academic Year & Semester seeded");

  // =========================================
  // 5. SEED SUBJECTS
  // =========================================
  console.log("📚 Seeding Subjects...");

  const subjects = [
    { name: "Matematika", code: "MTK" },
    { name: "Fisika", code: "FIS" },
    { name: "Kimia", code: "KIM" },
    { name: "Biologi", code: "BIO" },
    { name: "Bahasa Indonesia", code: "BIND" },
    { name: "Bahasa Inggris", code: "BING" },
    { name: "Sejarah", code: "SEJ" },
    { name: "Geografi", code: "GEO" },
    { name: "Ekonomi", code: "EKO" },
    { name: "Sosiologi", code: "SOS" },
    { name: "PJOK", code: "PJOK" },
    { name: "Seni Budaya", code: "SB" },
    { name: "PKN", code: "PKN" },
    { name: "Pendidikan Agama Islam", code: "PAI" },
    { name: "Informatika", code: "INF" },
  ];

  for (const subject of subjects) {
    await prisma.subject.upsert({
      where: {
        schoolId_name: {
          schoolId: school.id,
          name: subject.name,
        },
      },
      update: {
        schoolId: school.id,
        name: subject.name,
        code: subject.code,
      },
      create: {
        schoolId: school.id,
        name: subject.name,
        code: subject.code,
      },
    });
  }

  console.log("✅ Subjects seeded successfully");

  // =========================================
  // 6. SEED CLASSES
  // =========================================
  console.log("🏫 Seeding Classes...");

  const classes = [
    // Kelas 10
    { name: "X-1", gradeLevel: 10 },
    { name: "X-2", gradeLevel: 10 },
    { name: "X-3", gradeLevel: 10 },
    { name: "X-4", gradeLevel: 10 },

    // Kelas 11 IPA
    { name: "XI-IPA-1", gradeLevel: 11 },
    { name: "XI-IPA-2", gradeLevel: 11 },
    { name: "XI-IPA-3", gradeLevel: 11 },

    // Kelas 11 IPS
    { name: "XI-IPS-1", gradeLevel: 11 },
    { name: "XI-IPS-2", gradeLevel: 11 },

    // Kelas 12 IPA
    { name: "XII-IPA-1", gradeLevel: 12 },
    { name: "XII-IPA-2", gradeLevel: 12 },
    { name: "XII-IPA-3", gradeLevel: 12 },

    // Kelas 12 IPS
    { name: "XII-IPS-1", gradeLevel: 12 },
    { name: "XII-IPS-2", gradeLevel: 12 },
  ];

  for (const classData of classes) {
    await prisma.class.upsert({
      where: {
        schoolId_academicYearId_name: {
          schoolId: school.id,
          academicYearId: academicYear.id,
          name: classData.name,
        },
      },
      update: {
        schoolId: school.id,
        academicYearId: academicYear.id,
        name: classData.name,
        gradeLevel: classData.gradeLevel,
      },
      create: {
        schoolId: school.id,
        academicYearId: academicYear.id,
        name: classData.name,
        gradeLevel: classData.gradeLevel,
      },
    });
  }

  console.log("✅ Classes seeded successfully");

  const adminEmail = allowedEmails.find(
    (e) => e.roleId === adminRole.id,
  )?.email!;

  const operatorEmail = allowedEmails.find(
    (e) => e.roleId === operatorRole.id,
  )?.email!;

  const kepsekEmail = allowedEmails.find(
    (e) => e.roleId === kepsekRole.id,
  )?.email!;

  const guruEmail = allowedEmails.find((e) => e.roleId === guruRole.id)?.email!;

  // =========================================
  // SUMMARY
  // =========================================
  console.log("\n🎉 Seeding completed successfully!");
  console.log("\n📊 Summary:");
  console.log(`   - School: ${school.name}`);
  console.log(
    `   - Roles: ${[adminRole, operatorRole, kepsekRole, guruRole].length}`,
  );
  console.log(`   - Allowed Emails: ${allowedEmails.length}`);
  console.log(`   - Academic Year: ${academicYear.name}`);
  console.log(`   - Semesters: 2 (Ganjil & Genap)`);
  console.log(`   - Subjects: ${subjects.length}`);
  console.log(`   - Classes: ${classes.length}`);
  console.log("\n📝 Next Steps:");
  console.log("   1. Setup Google OAuth di aplikasi Anda");
  console.log("   2. User bisa login dengan email yang sudah terdaftar");
  console.log(
    "   3. Pada login pertama, user akan otomatis dibuat dengan role sesuai AllowedEmail",
  );
  console.log(
    "   4. Untuk multi-role (KEPSEK+GURU), tambahkan role kedua setelah login",
  );
  console.log("\n💡 Test Accounts:");
  console.log(`   ADMIN:    ${adminEmail}`);
  console.log(`   OPERATOR: ${operatorEmail}`);
  console.log(`   KEPSEK:   ${kepsekEmail}`);
  console.log(`   GURU:     ${guruEmail}`);

  console.log(`\nSchool ID: ${school.id}`);
  console.log("\n🎉 Seeding completed successfully!");
}

main()
  .catch((e) => {
    console.error("❌ Seeding failed:", e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
