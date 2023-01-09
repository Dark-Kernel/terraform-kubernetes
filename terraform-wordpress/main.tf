terraform{

  required_providers {

    docker = {

      source = "kreuzwerker/docker"
      version = "2.21.0"

    }

  }

}


provider "docker" {}

resource "docker_image" "wordpress" {

  name = "wordpress:latest"
  keep_locally = false

}

resource "docker_image" "mysql" {

  name = "mysql:8"
  keep_locally = false 

}

resource "docker_container" "wordpress" {

  image = docker_image.wordpress.latest
  name = "wordpress-tf"
  ports {

    internal = 80
    external = 70

  }
  env = [
    "WORDPRESS_DB_HOST = mysql",
    "WORDPRESS_DB_USER = root",
    "WORDPRESS_DB_PASSWORD = password",
    "WORDPRESS_DB_NAME = wordpress"
  ]

}


resource "docker_container" "mysql" {
  
  image = "${docker_image.mysql.latest}"
  name = "mysql"
  env = [

    "MYSQL_ROOT_PASSWORD = password",
    "MYSQL_DATABASE = wordpress" 

  ]
  mounts {
    source = "/var/lib/mysql/"
    target = "/var/lib/mysql/db"
    type = "bind"
  }
  ports {

    internal = 3306
    external = 3306 

  }
}


