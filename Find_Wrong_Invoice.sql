WITH invoice_numbers_adjust AS (
  SELECT track, begin_number,
    CASE
      WHEN track = 'AC' THEN 45678988
      ELSE end_number
    END AS adjusted_end_number
  FROM invoice_books
)
,numbers AS (
    SELECT
        track,
        begin_number AS number,
        adjusted_end_number
    FROM invoice_numbers_adjust
    UNION ALL
    SELECT
        track,
        number + 1,
        adjusted_end_number
    FROM numbers
    WHERE number < adjusted_end_number
)
, invoice_numbers_combine AS(
  SELECT CONCAT(track, '-', number) AS invoice_numbers 
  FROM numbers
  ORDER BY invoice_numbers
)
SELECT a.invoice_number
FROM invoice_numbers_combine a
LEFT JOIN invoices b ON a.invoice_number = b.invoice_number
WHERE b.invoice_number IS NULL;
