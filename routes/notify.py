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
            SELECT in_app_notifications
            FROM notification_preferences
            WHERE client_id = %s
            LIMIT 1
            """,
            (user_id,),
        )
        preferences = cursor.fetchone()
        if preferences is not None:
            if isinstance(preferences, dict):
                enabled = bool(preferences.get("in_app_notifications"))
            else:
                enabled = bool(preferences[0])
            if not enabled:
                return None

        cursor.execute(
            """
            INSERT INTO notifications (user_id, type, title, body, channel, is_read)
            VALUES (%s, %s, %s, %s, 'in_app', 0)
            """,
            (user_id, type_, title, body),
        )
        return cursor.lastrowid
    except Exception:
        return None
