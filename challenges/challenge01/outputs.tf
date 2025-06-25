output "project_id" {
  value = google_project.project.project_id
}

output "bucket_name" {
  value = google_storage_bucket.sensitive_data.name
}
