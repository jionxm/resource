insert into t_redis_config
(redis_version,os,run_id,arch_bits,process_id,tcp_port,connected_clients)
values (#{data.version},#{data.os},#{data.runId},#{data.archBits},#{data.processId},#{data.port},#{data.clients})