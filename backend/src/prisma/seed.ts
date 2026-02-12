import prisma from "../config/prisma";

async function main() {
  // console.log("🌱 Dropping existing data...");

  // await prisma.allowedEmail.deleteMany();
  // await prisma.userRole.deleteMany();
  // await prisma.user.deleteMany();
  // await prisma.school.deleteMany();
  // await prisma.role.deleteMany();
  // await prisma.teacher.deleteMany();
  // await prisma.class.deleteMany();
  // await prisma.subject.deleteMany();
  // await prisma.teacherSubject.deleteMany();

  console.log("🌱 Seeding initial data...");

  const adminRole = await prisma.role.upsert({
    where: { name: "ADMIN" },
    update: {},
    create: { name: "ADMIN" },
  });

  await prisma.role.upsert({
    where: { name: "OPERATOR" },
    update: {},
    create: { name: "OPERATOR" },
  });

  await prisma.role.upsert({
    where: { name: "KEPSEK" },
    update: {},
    create: { name: "KEPSEK" },
  });

  const guruRole = await prisma.role.upsert({
    where: { name: "GURU" },
    update: {},
    create: { name: "GURU" },
  });

  let school = await prisma.school.findFirst({
    where: { name: "SDN 1 Tassese Manuju" },
  });

  if (!school) {
    school = await prisma.school.create({
      data: {
        name: "SDN 1 Tassese Manuju",
        address: "Alamat dummy",
      },
    });
  }

  const adminUser = await prisma.user.upsert({
    where: { email: "knabilhakin@gmail.com" },
    update: {
      name: "Admin Demo",
      email: "knabilhakin@gmail.com",
      schoolId: school.id,
      isActive: true,
    },
    create: {
      name: "Admin Demo",
      email: "knabilhakin@gmail.com",
      schoolId: school.id,
      isActive: true,
    },
  });

  await prisma.userRole.upsert({
    where: {
      userId_roleId: {
        userId: adminUser.id,
        roleId: adminRole.id,
      },
    },
    update: {},
    create: {
      userId: adminUser.id,
      roleId: adminRole.id,
    },
  });

  const guruUser = await prisma.user.upsert({
    where: { email: "nakim050206@gmail.com" },
    update: {
      name: "Guru Demo",
      email: "nakim050206@gmail.com",
      schoolId: school.id,
      isActive: true,
    },
    create: {
      name: "Guru Demo",
      email: "nakim050206@gmail.com",
      schoolId: school.id,
      isActive: true,
    },
  });

  await prisma.userRole.upsert({
    where: {
      userId_roleId: {
        userId: guruUser.id,
        roleId: guruRole.id,
      },
    },
    update: {},
    create: {
      userId: guruUser.id,
      roleId: guruRole.id,
    },
  });

  await prisma.allowedEmail.upsert({
    where: { email: "knabilhakin@gmail.com" },
    update: { isActive: true },
    create: { email: "knabilhakin@gmail.com" },
  });

  await prisma.allowedEmail.upsert({
    where: { email: "nakim050206@gmail.com" },
    update: { isActive: true },
    create: { email: "nakim050206@gmail.com" },
  });

  console.log("✅ Seed completed");
}

main()
  .catch(console.error)
  .finally(() => prisma.$disconnect());
