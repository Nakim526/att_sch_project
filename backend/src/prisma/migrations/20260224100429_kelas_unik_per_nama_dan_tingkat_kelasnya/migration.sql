/*
  Warnings:

  - A unique constraint covering the columns `[schoolId,academicYearId,name,gradeLevel]` on the table `Class` will be added. If there are existing duplicate values, this will fail.

*/
-- DropIndex
DROP INDEX "Class_schoolId_academicYearId_name_key";

-- CreateIndex
CREATE UNIQUE INDEX "Class_schoolId_academicYearId_name_gradeLevel_key" ON "Class"("schoolId", "academicYearId", "name", "gradeLevel");
