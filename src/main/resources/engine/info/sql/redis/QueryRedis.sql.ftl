select * from (
	SELECT 
	  id as id,
	  redis_key as redisKey,
	  redis_value as redisValue
	  from t_redis 
) a 