def push_notification(cursor, user_id, type_, title, body=""):
    """
    Insert a single in-app notification row using an existing cursor.
    The caller is responsible for committing the transaction.
    Errors are silently swallowed so a failed notification never crashes
    the main operation.
    """
    try:
        cursor.execute(
            """
            INSERT INTO notifications (user_id, type, title, body, channel, is_read)
            VALUES (%s, %s, %s, %s, 'in_app', 0)
            """,
            (user_id, type_, title, body),
        )
    except Exception as e:
        print(f"[push_notification ERROR] user_id={user_id} type={type_} title={title!r} error={e}")
