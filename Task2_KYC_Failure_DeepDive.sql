-- Task 2: KYC Failure Deep-Dive

WITH failed_attempts AS (
    SELECT
        user_id,
        document_type,
        vendor_status
    FROM kyc_attempts
    WHERE verification_timestamp >= '2026-04-01'
      AND verification_timestamp < '2026-05-01'
      AND vendor_status IN (
          'failed_clear_error',
          'failed_suspected_fraud'
      )
      AND user_id NOT IN (
          SELECT user_id
          FROM kyc_attempts
          WHERE vendor_status = 'passed'
      )
)
SELECT
    document_type,
    vendor_status AS failure_type,
    COUNT(*) AS failure_count,
    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (PARTITION BY document_type),
        2
    ) AS failure_percentage
FROM failed_attempts
GROUP BY document_type, vendor_status
ORDER BY document_type, failure_percentage DESC;
