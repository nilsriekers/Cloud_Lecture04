# Dieser Code ist mit Terraform 4.25.0 und Versionen kompatibel, die mit 4.25.0 abwärtskompatibel sind.
# Informationen zum Validieren dieses Terraform-Codes finden Sie unter https://developer.hashicorp.com/terraform/tutorials/gcp-get-started/google-cloud-platform-build#format-and-validate-the-configuration.

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

provider "google" {
  project = "ccii-415711"
  region  = "europe-west1"
  zone    = "europe-west1-b"
}

resource "google_compute_instance" "gcp-vm2" {
  boot_disk {
    auto_delete = true
    device_name = "gcp-vm2"

    initialize_params {
      image = "projects/debian-cloud/global/images/debian-12-bookworm-v20240213"
      size  = 10
      type  = "pd-balanced"
    }

    mode = "READ_WRITE"
  }

  can_ip_forward      = false
  deletion_protection = false
  enable_display      = false

  labels = {
    goog-ec-src = "vm_add-tf"
  }

  machine_type = "e2-micro"

  metadata = {
    ssh-keys = "nilsriekers:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDHZhd1TNHJruAhbIPBiyrwM52wx52ale9TMfMfONrDPvNZKB5ElL/vR16P/BFbwYEYY+QhZldRQIImm7HEwbonvGfG4vLQ647noKYJcfoqAt5XcYkwi/mJBwiek6/tcSSRyNFw3Or4y5m0q/OX7uBgI+ZcbS4l4OT20gs31+guPXc1rXgW4J326UXotEO7WR0qZdolxTZEBfOhjNYfx4vIG48C6xsv8q0AxQplgwAOBIQmFqcZJCJYxNALJbrpL+Iuw9Q/2yNGgk2xMQzdoLIKRhnVftZnkHyXpFlQWz0nDLT03YnqhWy0JXEjn8aiBRbacER3YC0YPcM+mK4bflUJZ4rg13uusyxdMOO0Cc4HX42Dw21eTospmrP/S7KoU8nKT2Yvvk3hducqSpRZ/DRDWQOVfh2GRh/odyJ2YjtYBDROnrhQWWMWc+2tRGDL7KuP7jilP4OeB7ctvkYQg1g+VIS1Qpvn2nge7J+yPyBJf/Y0i6doqoX/iebxdvop1RcYTJiapZTYIfvQHdUzpwXfxDFag/YdZ60Kn1hY386TSS/yRV5jmTJEAobYBe1axAenacgjXBmn47vL09Lv8nGfb0sMo6dQPagKe0uEd0sTGx76IyBHq5CulhvR4zAgC5RN8YGnC6L/63AB2jJkJcTgFYZ2blzX61AbXVWG6kqvSw== nilsriekers@gcp-vm1.europe-west4-a.c.ccii-415711.internal"
  }

  name = "gcp-vm2"

  network_interface {
    access_config {
      network_tier = "PREMIUM"
    }

    queue_count = 0
    stack_type  = "IPV4_ONLY"
    subnetwork  = "projects/ccii-415711/regions/us-central1/subnetworks/default"
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    preemptible         = false
    provisioning_model  = "STANDARD"
  }

  service_account {
    email  = "583128800552-compute@developer.gserviceaccount.com"
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  shielded_instance_config {
    enable_integrity_monitoring = true
    enable_secure_boot          = false
    enable_vtpm                 = true
  }

  tags = ["http-server", "https-server"]
  zone = "us-central1-a"
}

