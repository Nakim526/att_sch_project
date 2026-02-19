/*
  Warnings:

  - You are about to drop the column `type` on the `Semester` table. All the data in the column will be lost.
  - A unique constraint covering the columns `[academicYearId,name]` on the table `Semester` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `name` to the `Semester` table without a default value. This is not possible if the table is not empty.

*/
-- DropIndex
DROP INDEX "Semester_academicYearId_type_key";

-- AlterTable
ALTER TABLE "Semester" DROP COLUMN "type",
ADD COLUMN     "name" "SemesterType" NOT NULL;

-- CreateIndex
CREATE UNIQUE INDEX "Semester_academicYearId_name_key" ON "Semester"("academicYearId", "name");
