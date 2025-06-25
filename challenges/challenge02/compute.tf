resource "google_compute_network" "network" {
  name                    = "c02-net"
  auto_create_subnetworks = false
  project                 = google_project.project_a.project_id

  depends_on = [time_sleep.wait_for_compute_api_project_a]
}

resource "google_compute_subnetwork" "subnet" {
  name          = "c02-subnet"
  ip_cidr_range = "10.140.0.0/24"
  region        = var.region
  network       = google_compute_network.network.id
  project       = google_project.project_a.project_id

  private_ip_google_access = true
}

resource "google_compute_firewall" "allow_ssh_from_iap" {
  name    = "allow-ssh-from-iap"
  network = google_compute_network.network.name
  project = google_project.project_a.project_id

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["35.235.240.0/20"]
  target_tags   = ["ssh"]
}

resource "google_compute_instance" "vm" {
  name         = "c02-vm"
  machine_type = "e2-small"
  zone         = var.zone
  project      = google_project.project_a.project_id

  tags = ["ssh"]

  boot_disk {
    initialize_params {
      image = "projects/debian-cloud/global/images/family/debian-11"
    }
  }

  network_interface {
    network    = google_compute_network.network.id
    subnetwork = google_compute_subnetwork.subnet.id
  }

  shielded_instance_config {
    enable_secure_boot          = true
    enable_vtpm                 = true
    enable_integrity_monitoring = true
  }

  service_account {
    email  = google_service_account.vm_sa.email
    scopes = ["cloud-platform"]
  }

  metadata = {
    enable-oslogin = "TRUE"
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    echo "CTF VM ready"
  EOT
}
