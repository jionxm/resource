UPDATE t_meeting meet
LEFT JOIN t_meeting_detail d ON d.meeting_id =meet.id
LEFT JOIN t_issue i ON i.id = d.issue_id
SET meet.`status` = 'unkown'
WHERE
	ISNULL(d.id);UPDATE t_meeting meet
SET `status` = 'doing'
WHERE
	meet.id IN (
		SELECT
			meeting_id
		FROM
			t_meeting_detail d
		LEFT JOIN t_issue i ON i.id = d.issue_id
		WHERE
			EXISTS (
				SELECT
					*
				FROM
					t_issue
				WHERE
					`status` IN (
						'close',
						'cancel',
						'test',
						'reopen',
						'workin',
						'resolve'
					)
				AND i.id = id
			)
	);UPDATE t_meeting meet
SET `status` = 'end'
WHERE
	meet.id NOT IN (
		SELECT
			meeting_id
		FROM
			t_meeting_detail d
		LEFT JOIN t_issue i ON i.id = d.issue_id
		WHERE
			 EXISTS (
				SELECT
					*
				FROM
					t_issue
				WHERE
					`status` IN (
						'open',
						'test',
						'reopen',
						'workin',
						'resolve'
					)
				AND i.id = id
			)
	)