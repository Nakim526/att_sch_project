/*
  Warnings:

  - You are about to drop the column `roleId` on the `AllowedEmail` table. All the data in the column will be lost.
  - You are about to drop the column `googleId` on the `User` table. All the data in the column will be lost.
  - A unique constraint covering the columns `[userId]` on the table `AllowedEmail` will be added. If there are existing duplicate values, this will fail.

*/
-- DropForeignKey
ALTER TABLE "AllowedEmail" DROP CONSTRAINT "AllowedEmail_roleId_fkey";

-- DropIndex
DROP INDEX "AllowedEmail_email_key";

-- DropIndex
DROP INDEX "User_googleId_idx";

-- DropIndex
DROP INDEX "User_googleId_key";

-- AlterTable
ALTER TABLE "AllowedEmail" DROP COLUMN "roleId";

-- AlterTable
ALTER TABLE "User" DROP COLUMN "googleId";

-- CreateIndex
CREATE UNIQUE INDEX "AllowedEmail_userId_key" ON "AllowedEmail"("userId");
