1.	a) How many campaigns and sources does CoolTShirts use? 

SELECT COUNT(DISTINCT utm_campaign) AS 'Unique Campaigns',
COUNT(DISTINCT utm_source) AS 'Unique Sources'
FROM page_visits;

1.	b) Which source is used for each campaign?

SELECT DISTINCT utm_campaign AS 'Campaign',
utm_source AS 'Source'
FROM page_visits;

2.	What pages are on the CoolTShirts website?

SELECT DISTINCT page_name AS 'Page Name'
FROM page_visits;

3.	How many first touches is each campaign responsible for?

WITH first_touch AS (
    SELECT user_id,
        MIN(timestamp) AS first_touch_at
    FROM page_visits
    GROUP BY user_id),
ft_attrib AS (
  SELECT ft.user_id,
         ft.first_touch_at,
         pv.utm_source,
         pv.utm_campaign
  FROM first_touch AS ft
  JOIN page_visits AS pv
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp
)
SELECT ft_attrib.utm_campaign AS 'Campaign',
       ft_attrib.utm_source AS 'Source',
       COUNT(*) AS '# First Touches'
FROM ft_attrib
GROUP BY 1, 2
ORDER BY 3 DESC;

4.	How many last touches is each campaign responsible for?

WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) AS last_touch_at
    FROM page_visits
    GROUP BY user_id),
lt_attrib AS (
  SELECT lt.user_id,
         lt.last_touch_at,
         pv.utm_source,
         pv.utm_campaign
  FROM last_touch AS lt
  JOIN page_visits AS pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
)
SELECT lt_attrib.utm_campaign AS 'Campaign',
       lt_attrib.utm_source AS 'Source',
       COUNT(*) AS '# Last Touches'
FROM lt_attrib
GROUP BY 1, 2
ORDER BY 3 DESC;

5.	How many visitors make a purchase?

SELECT COUNT(DISTINCT user_id) AS '# Visitors Who Make a Purchase'
FROM page_visits
WHERE page_name = '4 - purchase';

6.	How many last touches on the purchase page is each campaign responsible for?

WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) AS last_touch_at
    FROM page_visits
  	WHERE page_name = '4 - purchase'
    GROUP BY user_id),
lt_attrib AS (
  SELECT lt.user_id,
         lt.last_touch_at,
         pv.utm_source,
         pv.utm_campaign,
         pv.page_name
  FROM last_touch AS lt
  JOIN page_visits AS pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
)
SELECT lt_attrib.utm_campaign AS 'Campaign',
       lt_attrib.utm_source AS 'Source',
       COUNT(*) AS '# Purchase Last Touches'
FROM lt_attrib
GROUP BY 1, 2
ORDER BY 3 DESC;


