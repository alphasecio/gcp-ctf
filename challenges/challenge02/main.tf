resource "random_id" "suffix" {
  byte_length = 2 # This will generate a 4-character hex string (2 bytes * 2 hex chars/byte)
}

resource "google_project" "project_a" {
  name            = "Challenge 02 - Project A"
  project_id      = "ctf-c02-proj-a-${random_id.suffix.hex}"
  folder_id       = var.ctf_folder_id
  billing_account = var.billing_account_id

  lifecycle {
    prevent_destroy = false
  }
}

resource "google_project" "project_b" {
  name            = "Challenge 02 - Project B"
  project_id      = "ctf-c02-proj-b-${random_id.suffix.hex}"
  folder_id       = var.ctf_folder_id
  billing_account = var.billing_account_id

  lifecycle {
    prevent_destroy = false
  }
}

resource "google_project_service" "project_a_apis" {
  provider = google.project_a
  for_each = toset([
    "compute.googleapis.com",
    "iam.googleapis.com",
    "storage.googleapis.com",
    "iap.googleapis.com"
  ])
  project = google_project.project_a.project_id
  service = each.key
}

resource "time_sleep" "wait_for_compute_api_project_a" {
  depends_on = [google_project_service.project_a_apis["compute.googleapis.com"]]
  create_duration = "60s"
}

resource "google_project_service" "project_b_apis" {
  provider = google.project_b
  for_each = toset([
    "iam.googleapis.com",
    "storage.googleapis.com"
  ])
  project = google_project.project_b.project_id
  service = each.key
}

provider "google" {
  alias   = "project_a"
  project = google_project.project_a.project_id
  region  = var.region
  zone    = var.zone
}

provider "google" {
  alias   = "project_b"
  project = google_project.project_b.project_id
  region  = var.region
  zone    = var.zone
}
