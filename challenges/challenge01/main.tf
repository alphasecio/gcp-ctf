resource "random_id" "suffix" {
  byte_length = 2 # This will generate a 4-character hex string (2 bytes * 2 hex chars/byte)
}

resource "google_project" "project" {
  name            = "Challenge 01 - Project"
  project_id      = "ctf-c01-proj-${random_id.suffix.hex}"
  folder_id       = var.ctf_folder_id
  billing_account = var.billing_account_id

  lifecycle {
    prevent_destroy = false
  }
}

resource "time_sleep" "wait_for_project_creation" {
  depends_on = [google_project.project]
  create_duration = "30s" # Adjust as needed, 30-60s is often sufficient
}

resource "google_project_service" "project_apis" {
  for_each = toset([
    "iam.googleapis.com",
    "storage.googleapis.com",
  ])
  project = google_project.project.project_id
  service = each.key
  
  depends_on = [time_sleep.wait_for_project_creation]
}

provider "google" {
  region  = var.region
}
