data "alicloud_instance_types" "1c2g" {
	cpu_core_count = 1
	memory_size = 2
	instance_type_family = "ecs.n1"
}

data "alicloud_zones" "default" {
	"available_instance_type"= "${data.alicloud_instance_types.4c8g.instance_types.0.id}"
	"available_disk_category"= "${var.disk_category}"
}

resource "alicloud_security_group" "group" {
  name = "${var.short_name}"
  description = "New security group"
}

resource "alicloud_instance" "instance" {
  instance_name = "${var.short_name}-${var.role}-${format(var.count_format, count.index+1)}"
  host_name = "${var.short_name}-${var.role}-${format(var.count_format, count.index+1)}"
  image_id = "${var.image_id}"
  instance_type = "${data.alicloud_instance_types.1c2g.instance_types.0.id}"
  count = "${var.count}"
  availability_zone = "${data.alicloud_zones.default.zones.0.id}"
  security_groups = ["${alicloud_security_group.group.*.id}"]

  internet_charge_type = "${var.internet_charge_type}"
  internet_max_bandwidth_out = "${var.internet_max_bandwidth_out}"

  io_optimized = "${var.io_optimized}"

  password = "${var.ecs_password}"

  instance_charge_type = "PostPaid"
  system_disk_category = "${var.disk_category}"


  tags {
    role = "${var.role}"
    dc = "${var.datacenter}"
  }

}
