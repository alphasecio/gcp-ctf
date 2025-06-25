resource "google_storage_bucket" "sensitive_data" {
  name          = "c02-sensitive-data-${random_id.suffix.hex}"
  location      = var.region
  project       = google_project.project_b.project_id
  force_destroy = true
  uniform_bucket_level_access = true
}

resource "google_storage_bucket_object" "sensitive_file" {
  name   = "sensitive-data.txt"
  bucket = google_storage_bucket.sensitive_data.name
  source = "${path.module}/sensitive-data.txt"
}
