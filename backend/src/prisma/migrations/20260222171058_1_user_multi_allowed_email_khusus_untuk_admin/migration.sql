/*
  Warnings:

  - A unique constraint covering the columns `[email]` on the table `AllowedEmail` will be added. If there are existing duplicate values, this will fail.

*/
-- DropIndex
DROP INDEX "AllowedEmail_userId_key";

-- CreateIndex
CREATE UNIQUE INDEX "AllowedEmail_email_key" ON "AllowedEmail"("email");
