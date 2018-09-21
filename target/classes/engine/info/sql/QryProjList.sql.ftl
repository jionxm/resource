select * from (
    select
    p.id,
    p.create_time as createTime,
    p.update_time as updateTime,
    e.name as createByName,
    em.name as updateByName,
    em1.name as projectManagerName,
    p.project_manager as projectManager,
    em2.name as testManagerName,
    p.test_manager as testManager,
    em3.name as productManagerName,
    p.product_manager as productManager,
    p.code_repo_url as codeRepoUrl,
    p.description,
    p.name,
    p.status,
    d.name as statusName
    from t_project p
    LEFT Join t_dict d
    on p.status = d.code
    LEFT JOIN t_employee e
    on p.create_by = e.id
    LEFT JOIN t_employee em
    on p.update_by = em.id
    LEFT JOIN t_employee em1
    on p.project_manager = em1.id
    LEFT JOIN t_employee em2
    on p.test_manager = em2.id
    LEFT JOIN t_employee em3
    on p.product_manager = em3.id
    where d.cata_code = 't_project.status'
    order by createTime desc
) a