import html
import json
import os
import urllib.error
import urllib.request


def _get_value(row, key, index, default=None):
    if row is None:
        return default
    if isinstance(row, dict):
        return row.get(key, default)
    return row[index] if len(row) > index else default


def _send_resend_email(to_email, subject, body):
    api_key = os.getenv("RESEND_API_KEY")
    if not api_key:
        print("Resend email skipped: RESEND_API_KEY is not set")
        return False
    if not to_email:
        print("Resend email skipped: recipient email is missing")
        return False

    if os.getenv("EMAIL_DEBUG", "").lower() == "true":
        print(f"Resend email attempt: to={to_email}, subject={subject}")

    if not api_key or not to_email:
        return

    from_email = os.getenv("EMAIL_FROM", "BitFit <onboarding@resend.dev>")
    payload = {
        "from": from_email,
        "to": [to_email],
        "subject": subject,
        "html": f"""
            <div style="font-family:Arial,sans-serif;line-height:1.5;color:#111827">
              <h2 style="margin:0 0 12px">BitFit</h2>
              <p>{html.escape(body or subject)}</p>
            </div>
        """,
    }

    req = urllib.request.Request(
        "https://api.resend.com/emails",
        data=json.dumps(payload).encode("utf-8"),
        headers={
            "Authorization": f"Bearer {api_key}",
            "Content-Type": "application/json",
        },
        method="POST",
    )

    try:
        with urllib.request.urlopen(req, timeout=8):
            print(f"Resend email sent: to={to_email}, subject={subject}")
            return True
    except urllib.error.HTTPError as e:
        print(f"Resend email failed: {e.code} {e.read().decode('utf-8', errors='ignore')}")
    except Exception as e:
        print(f"Resend email failed: {e}")
    return False


def push_notification(cursor, user_id, type_, title, body="", send_email=False):
    """
    Insert a single in-app notification row using an existing cursor.
    The caller is responsible for committing the transaction.
    Errors are silently swallowed so a failed notification never crashes
    the main operation.
    """
    try:
        cursor.execute(
            """
            SELECT
                COALESCE(np.in_app_notifications, 1) AS in_app_notifications,
                COALESCE(np.email_notifications, 1) AS email_notifications,
                c.email
            FROM client c
            LEFT JOIN notification_preferences np ON c.client_id = np.client_id
            WHERE c.client_id = %s
            LIMIT 1
            """,
            (user_id,),
        )
        preferences = cursor.fetchone()
        in_app_enabled = bool(_get_value(preferences, "in_app_notifications", 0, True))
        email_enabled = bool(_get_value(preferences, "email_notifications", 1, False))
        email = _get_value(preferences, "email", 2)

        if send_email and os.getenv("EMAIL_DEBUG", "").lower() == "true":
            print(
                "Notification email check: "
                f"user_id={user_id}, email={email}, email_enabled={email_enabled}, title={title}"
            )

        notification_id = None
        if in_app_enabled:
            cursor.execute(
                """
                INSERT INTO notifications (user_id, type, title, body, channel, is_read)
                VALUES (%s, %s, %s, %s, 'in_app', 0)
                """,
                (user_id, type_, title, body),
            )
            notification_id = cursor.lastrowid

        if send_email and email_enabled:
            _send_resend_email(email, title, body)
        elif send_email:
            print(f"Resend email skipped: email notifications disabled for user_id={user_id}")

        return notification_id
    except Exception as e:
        print(f"Notification failed: user_id={user_id}, title={title}, error={e}")
        return None
