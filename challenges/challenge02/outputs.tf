output "project_a_id" {
  value = google_project.project_a.project_id
}

output "project_b_id" {
  value = google_project.project_b.project_id
}

output "vm_service_account" {
  value = google_service_account.vm_sa.email
}

output "gcs_service_account" {
  value = google_service_account.gcs_sa.email
}

output "bucket_name" {
  value = google_storage_bucket.sensitive_data.name
}
