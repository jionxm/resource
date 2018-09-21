insert into t_push (p_before,after,ref,user_name,user_email,total_commits_count,repository)
VALUES (#{data.before},#{data.after},#{data.ref},#{data.user_name},#{data.user_email},#{data.total_commits_count},#{data.repository});
