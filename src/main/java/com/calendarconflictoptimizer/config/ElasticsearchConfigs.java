package com.calendarconflictoptimizer.config;

import co.elastic.clients.elasticsearch.ElasticsearchClient;
import co.elastic.clients.transport.rest_client.RestClientTransport;
import co.elastic.clients.json.jackson.JacksonJsonpMapper;

import jakarta.annotation.Resource;

import org.apache.http.HttpHost;
import org.elasticsearch.client.RestClient;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.env.Environment;
import org.springframework.data.elasticsearch.repository.config.EnableElasticsearchRepositories;

@Configuration
@EnableElasticsearchRepositories(basePackages = "com.calendarconflictoptimizer.repository")
public class ElasticsearchConfigs {

	@Resource
	private Environment environment;

	@Bean
	public RestClient restClient() {
		return RestClient.builder(
				new HttpHost(
						environment.getProperty("elasticsearch.host", "localhost"),
						Integer.parseInt(environment.getProperty("elasticsearch.port", "9200")),
						"http"
				)
		).build();
	}

	@Bean
	public ElasticsearchClient elasticsearchClient(RestClient restClient) {
		RestClientTransport transport = new RestClientTransport(restClient, new JacksonJsonpMapper());
		return new ElasticsearchClient(transport);
	}
}
