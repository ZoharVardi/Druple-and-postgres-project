# Drupal + PostgreSQL Docker Setup
by:Adi Binyamin,Zohar Vardi and Ido Muallem

Technologies Used in This Project

This project leverages Docker to containerize and manage a Drupal website with a PostgreSQL database, ensuring a consistent and portable development environment. Docker Compose is used to orchestrate multi-container deployment, creating an isolated network where Drupal and PostgreSQL communicate seamlessly. Bash scripting automates setup, backup, and cleanup operations, simplifying the process of restoring and maintaining the site. PostgreSQL is chosen as the database for its performance and reliability, while Drupal serves as the content management system (CMS), providing a flexible and scalable web platform. Additionally, Linux utilities such as unzip, sed, and chown are used to handle file operations and configurations efficiently. This stack ensures easy deployment, backup, and migration across different machines. 

---

## **Project Files**
- `setupAndRestore.sh` → **Sets up Drupal & PostgreSQL** and restores backups.
- `backup.sh` → **Creates a backup** of Drupal files & database.
- `cleanup.sh` → **Removes everything** (containers, volumes, images).
- `drupal_files.zip` → **Backup of the Drupal site files**.
- `backup.zip` → **Backup of the PostgreSQL database**.
- `README.md` → **This documentation file**.

---

1. Setup & Restore**
1️Make the script executable**:  
```bash
chmod +x setupAndRestore.sh

2️Run the script:

./setupAndRestore.sh

Access your site at:
http://localhost:8080/

2. Backup

To back up Drupal files and database, run:

chmod +x backup.sh
./backup.sh

This creates:

    drupal_files.zip → Drupal files backup
    backup.zip → Database backup

3. Cleanup

To remove everything, run:

chmod +x cleanup.sh
./cleanup.sh

 WARNING: This deletes all data (Drupal & database)!
