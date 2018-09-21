insert into t_customer (
name,
short_name,
create_time
)
values(
#{data.customerName},
#{data.customerName},
now()
);