<!DOCTYPE html>
<html class="pf-m-redhat-font">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Verification Pending</title>
    <style>
        body {
            background: linear-gradient(to right, #134153 0%, #238C8C 100%);
            background-size: cover;
            min-height: 100vh;
            margin: 0;
            padding: 20px;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, sans-serif;
        }
        /* Self-contained styles - works with any theme */
        .sumsub-pending-container {
            max-width: 600px;
            margin: 60px auto;
            background: rgba(255, 255, 255, 0.95);
            border-radius: 16px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            padding: 40px;
            text-align: center;
            border-top: 4px solid #238C8C;
        }
        .sumsub-icon { font-size: 64px; margin-bottom: 20px; }
        .sumsub-pending-container h1 { color: #134153; margin-bottom: 20px; font-size: 28px; font-weight: 600; }
        .sumsub-pending-container p { color: #666; margin-bottom: 15px; font-size: 16px; line-height: 1.6; }
        .sumsub-info {
            background: #e8f4f8;
            border: 1px solid #b3d9e6;
            color: #0c5460;
            padding: 15px;
            border-radius: 8px;
            margin: 20px 0;
            font-size: 14px;
            text-align: left;
        }
        .sumsub-warning {
            background: #fff3cd;
            border: 1px solid #ffc107;
            color: #856404;
            padding: 15px;
            border-radius: 8px;
            margin: 20px 0;
            font-size: 14px;
        }
        .sumsub-button {
            padding: 12px 32px;
            background: #238C8C;
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 16px;
            font-weight: 500;
            margin: 10px;
            transition: background-color 0.3s ease;
        }
        .sumsub-button:hover { background: #1A6B6B; }
        .sumsub-button-secondary { background: #6c757d; }
        .sumsub-button-secondary:hover { background: #545b62; }
    </style>
</head>
<body>
    <div class="sumsub-pending-container">
        <div class="sumsub-icon">⏳</div>
        <h1>Verification Under Review</h1>
        <p>Your documents have been submitted and are being reviewed by our verification team.</p>
        <p>This usually takes a few minutes during business hours.</p>

        <div class="sumsub-warning">
            <strong>Important:</strong> Your account will be verified automatically once the review is complete. You can close this page and login again later.
        </div>

        <div class="sumsub-info">
            <strong>What happens next:</strong><br>
            • We'll automatically update your status when review is complete<br>
            • You can login with your passkey once approved<br>
            • If rejected, you'll see instructions on next login attempt
        </div>

        <form method="post" action="${actionUrl}">
            <button type="submit" class="sumsub-button">Check Status Again</button>
            <button type="button" class="sumsub-button sumsub-button-secondary" onclick="window.close()">Close This Page</button>
        </form>
    </div>
</body>
</html>
