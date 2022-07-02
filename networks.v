module docker

import net.http { Method }
import json

// https://docs.docker.com/engine/api/v1.41/#operation/NetworkConnect

pub struct EndpointConfig {
	ipam_config EndpointIpamConfig [json: IPAMConfig]
}

pub struct NetworkConnectOptions {
	container       string         [json: Container]
	endpoint_config EndpointConfig [json: EndpointConfig]
}

pub fn (mut d DockerConn) network_connect(id string, net_id string) ? {
	n := NetworkConnectOptions{
		container: id
	}
	d.send_request_with_json(Method.post, '/networks/$net_id/connect', n)?

	head, body := d.read_response()?

	if head.status_code != 200 {
		data := json.decode(DockerError, body)?

		return error(data.message)
	}
}
