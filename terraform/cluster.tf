resource "template_file" "cluster_yml" {
    filename = "cluster.yml.template"
    vars {
        cluster_name = "cluster"
        operating_system = "ubuntu"
        aws_region = "${var.aws_region}"
        aws_availability_zone = "${var.aws_availability_zone}"
        aws_access_key = "${var.aws_access_key}"
        aws_secret_key = "${var.aws_secret_key}"
        private_key_path = "${var.private_key_path}"
        agent_nodes = "${join("", formatlist(" - {public: %v, private: %v}\n", aws_instance.nodes.*.public_ip, aws_instance.nodes.*.private_ip))}"
        master_dns_name = "${aws_instance.master.public_dns}"
    }
    provisioner "local-exec" {
        command = "echo '${self.rendered}' > cluster.yml"
    }
}
