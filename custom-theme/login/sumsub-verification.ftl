<!DOCTYPE html>
<html class="pf-m-redhat-font">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Identity Verification</title>
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
        .sumsub-container {
            max-width: 900px;
            margin: 40px auto;
            background: rgba(255, 255, 255, 0.95);
            border-radius: 16px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            padding: 40px;
            border-top: 4px solid #238C8C;
        }
        .sumsub-header {
            text-align: center;
            margin-bottom: 30px;
        }
        .sumsub-header h1 {
            color: #134153;
            font-size: 28px;
            margin-bottom: 10px;
            font-weight: 600;
        }
        .sumsub-header .subtitle {
            color: #666;
            font-size: 16px;
            line-height: 1.6;
        }
        #sumsub-loading {
            text-align: center;
            padding: 60px 20px;
        }
        .sumsub-spinner {
            width: 50px;
            height: 50px;
            border: 4px solid #e2e8f0;
            border-top-color: #238C8C;
            border-radius: 50%;
            animation: sumsub-spin 1s linear infinite;
            margin: 0 auto 20px;
        }
        @keyframes sumsub-spin {
            to { transform: rotate(360deg); }
        }
        #sumsub-websdk-container {
            min-height: 600px;
            border: 2px dashed #e2e8f0;
            border-radius: 8px;
            background: #fafafa;
        }
        #sumsub-error, #sumsub-success, #sumsub-timeout {
            display: none;
            text-align: center;
            padding: 40px;
        }
        #sumsub-error { color: #e53e3e; }
        #sumsub-success { color: #238C8C; }
        #sumsub-timeout {
            color: #856404;
            background: #fff3cd;
            border-radius: 8px;
            margin: 20px 0;
        }
        .kc-button {
            padding: 12px 32px;
            background: #238C8C;
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 16px;
            font-weight: 500;
            transition: background-color 0.3s ease;
        }
        .kc-button:hover {
            background: #1A6B6B;
        }
        .kc-button.primary {
            background: #238C8C;
        }
        .kc-button.primary:hover {
            background: #1A6B6B;
        }
    </style>
</head>
<body>
    <div class="sumsub-container">
        <div class="sumsub-header">
            <h1>Identity Verification</h1>
            <p class="subtitle">Please complete the identity verification process to continue.</p>
        </div>

        <div id="sumsub-loading">
            <div class="sumsub-spinner"></div>
            <p>Initializing verification widget...</p>
        </div>

        <div id="sumsub-error">
            <h3>Verification Failed</h3>
            <p id="sumsub-error-message">An error occurred during verification.</p>
        </div>

        <div id="sumsub-success">
            <h3>✅ Verification Approved!</h3>
            <p>You can now access your account. Redirecting...</p>
        </div>

        <div id="sumsub-timeout">
            <h3>⏱️ Review Taking Longer Than Expected</h3>
            <p>Your verification is still under review.</p>
            <p><strong>You can close this page.</strong></p>
            <p>We'll verify your identity automatically once the review is complete. You can login again later to check your status.</p>
            <form method="post" action="${actionUrl}">
                <button type="submit" class="kc-button primary">Check Status Again</button>
            </form>
        </div>

        <div id="sumsub-websdk-container"></div>

        <form id="verification-form" method="post" action="${actionUrl}" style="display:none;">
            <input type="hidden" name="applicantId" id="sumsub-applicant-id">
            <input type="hidden" name="verificationStatus" id="verification-status">
        </form>
    </div>

    <script src="https://static.sumsub.com/idensic/static/sns-websdk-builder.js"></script>
    <script>
    (function() {
        var config = {
            container: '#sumsub-websdk-container',
            accessToken: '${accessToken}',
            actionUrl: '${actionUrl}',
            levelName: '${levelName}',
            timeoutMs: 5 * 60 * 1000
        };
        var state = { sdk: null, applicantId: null, timeoutTimer: null };

        function submitForm(status) {
            console.log('Submitting form with status:', status, 'applicantId:', state.applicantId);
            document.getElementById('verification-status').value = status;
            var applicantIdInput = document.getElementById('sumsub-applicant-id');
            if (applicantIdInput) {
                applicantIdInput.value = state.applicantId || '';
            }
            var form = document.getElementById('verification-form');
            form.submit();
        }

        function hideElement(id) {
            var el = document.getElementById(id);
            if (el) el.style.display = 'none';
        }

        function showElement(id) {
            var el = document.getElementById(id);
            if (el) el.style.display = 'block';
        }

        document.addEventListener('DOMContentLoaded', function() {
            if (typeof snsWebSdk === 'undefined') {
                hideElement('sumsub-loading');
                showElement('sumsub-error');
                return;
            }

            try {
                state.sdk = snsWebSdk
                    .init(config.accessToken, function() { return Promise.resolve(config.accessToken); })
                    .withConf({ lang: 'en', theme: 'light' })
                    .withOptions({ addViewportTag: false, adaptIframeHeight: true })
                    .on('idCheck.onApplicantLoaded', function(payload) {
                        console.log('SumSub: Applicant loaded', payload);
                        hideElement('sumsub-loading');
                        // Extract applicantId from various possible payload structures
                        if (payload) {
                            if (payload.applicantId) {
                                state.applicantId = payload.applicantId;
                            } else if (payload.applicantId) {
                                state.applicantId = payload.applicantId;
                            }
                        }
                        console.log('Stored applicantId:', state.applicantId);
                    })
                    .on('idCheck.onApplicantSubmitted', function(payload) {
                        console.log('SumSub: Documents submitted', payload);
                        if (payload && payload.applicantId) {
                            state.applicantId = payload.applicantId;
                            console.log('Updated applicantId on submit:', state.applicantId);
                        }
                        state.timeoutTimer = setTimeout(function() {
                            hideElement('sumsub-websdk-container');
                            showElement('sumsub-timeout');
                        }, config.timeoutMs);
                    })
                    .on('idCheck.onApplicantStatusChanged', function(payload) {
                        console.log('SumSub: Status changed', payload);
                        if (!payload || !payload.reviewResult) return;
                        if (payload.reviewResult.reviewAnswer === 'GREEN') {
                            clearTimeout(state.timeoutTimer);
                            hideElement('sumsub-websdk-container');
                            showElement('sumsub-success');
                            setTimeout(function() { submitForm('approved'); }, 1500);
                        } else if (payload.reviewResult.reviewAnswer === 'RED') {
                            clearTimeout(state.timeoutTimer);
                            hideElement('sumsub-websdk-container');
                            showElement('sumsub-error');
                            var errorMsg = document.getElementById('sumsub-error-message');
                            if (errorMsg) errorMsg.textContent = 'Verification rejected. Please contact support.';
                            setTimeout(function() { submitForm('rejected'); }, 3000);
                        }
                    })
                    .on('idCheck.onApplicantReviewed', function(payload) {
                        console.log('SumSub: Applicant reviewed', payload);
                        if (!payload || !payload.reviewResult) return;
                        if (payload.reviewResult.reviewAnswer === 'GREEN') {
                            clearTimeout(state.timeoutTimer);
                            hideElement('sumsub-websdk-container');
                            showElement('sumsub-success');
                            if (payload.applicantId) state.applicantId = payload.applicantId;
                            setTimeout(function() { submitForm('approved'); }, 1500);
                        } else if (payload.reviewResult.reviewAnswer === 'RED') {
                            clearTimeout(state.timeoutTimer);
                            hideElement('sumsub-websdk-container');
                            showElement('sumsub-error');
                            setTimeout(function() { submitForm('rejected'); }, 3000);
                        }
                    })
                    .on('idCheck.onError', function(error) {
                        console.error('SumSub error:', error);
                        clearTimeout(state.timeoutTimer);
                        hideElement('sumsub-loading');
                        hideElement('sumsub-websdk-container');
                        showElement('sumsub-error');
                    })
                    .build();
                state.sdk.launch(config.container);
            } catch (error) {
                console.error('Failed to initialize SumSub SDK:', error);
                hideElement('sumsub-loading');
                showElement('sumsub-error');
            }
        });
    })();
    </script>
</body>
</html>
