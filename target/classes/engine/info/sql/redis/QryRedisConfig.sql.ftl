SELECT * FROM(
	SELECT
		id as id,
		redis_version as version,
		os as os,
		run_id as runId,
		arch_bits as archBits,
		process_id as processId,
		tcp_port as port,
		connected_clients as clients
	FROM t_redis_config
)a