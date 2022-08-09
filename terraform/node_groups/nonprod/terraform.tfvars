cluster_name         = "bahmni-cluster-nonprod"
node_role_name       = "BahmniEKSNodeRole-nonprod"
node_group_name      = "nonprod"
desired_num_of_nodes = 2
min_num_of_nodes     = 1
max_num_of_nodes     = 2
node_instance_type   = "m5.xlarge"
