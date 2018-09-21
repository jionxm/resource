select * from (
    select p.name,
    p.id,
    p.description,
    p.status
    from t_project p
) a