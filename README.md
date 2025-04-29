
# YouTube Trending Videos Analysis using Snowflake and SQL

📌 **Project Overview**  
This project analyzes **YouTube trending video data** collected from the **YouTube API** and posted on **Kaggle**.  
Using **SQL** and the **Snowflake data lake platform**, the goal is to uncover insights about the factors influencing video success.  
The analysis provides content creators with **strategies to improve their video reach and engagement** based on data-driven findings.

---

📖 **Objective**  
- Examine daily trending YouTube videos across 11 countries.
- Identify critical elements impacting video popularity.
- Provide actionable strategies for content creators to enhance discoverability and engagement.

---

🗄️ **Data Acquisition**
- **Data Period:** From 2020-08-12 to the present.
- **Countries Covered:** IN, US, GB, DE, CA, FR, RU, BR, MX, KR, JP (India, USA, UK, Germany, Canada, France, Russia, Brazil, Mexico, South Korea, Japan).
- **Files:**
  - CSV files for trending videos (one per country).
  - JSON files containing video category metadata.
- **Key Fields:** Title, Channel Name, Publish Date, Views, Likes, Dislikes, Comments.

---

🏗️ **Architecture**

| Table Name | Description |
|:-----------|:------------|
| `TABLE_YOUTUBE_TRENDING` | Trending video records (CSV source) |
| `TABLE_YOUTUBE_CATEGORY` | Video category metadata (JSON source) |
| `TABLE_YOUTUBE_FINAL` | Combined and cleaned dataset (1175478 records initially) |

**Storage & Ingestion:**  
- Data ingested via **Azure Storage** integration.
- Loaded into **Snowflake external tables** for further processing.

---

🧹 **Data Cleaning Process**
- Identified and fixed **duplicate categories** (e.g., Comedy duplicates).
- Handled **missing category titles** (e.g., Category ID 29 was missing).
- **Replaced NULL values** in `category_title`.
- Removed entries with invalid `video_id` (e.g., "#NAME?").
- Removed **duplicate records** using `ROW_NUMBER()`, resulting in:
  - **1123017 clean records** after deduplication.
- Validated record counts post-cleaning.

---

📊 **Data Analysis Process**

1. **Top 3 Sports Videos**:  
   - Identified the top 3 most-viewed sports videos per country on a specific trending date (2021-10-17).

2. **"BTS" Analysis:**  
   - Counted videos containing "BTS" in titles per country, sorted by frequency.

3. **Top Videos by Like Ratio:**  
   - Found the top video by country, year, and month with the highest like-to-view ratio (rounded to 2 decimals).

4. **Top Categories:**  
   - For each country, determined the most common video category and its share of total distinct videos.

5. **Top YouTube Channels:**  
   - Identified channels with the most distinct trending videos.

---

❓ **Business Insights**

- **Music and Entertainment** dominate trending charts across most countries.
- **People & Blogs**, **Gaming**, **Sports**, and **Comedy** are highly competitive genres.
- Country-specific trends observed:
  - Gaming is top in Canada and USA.
  - Sports is dominant in Denmark.
- **People and Blogs** was the most frequent trending category in 6 of 11 countries analyzed.

**Content Strategy Recommendation:**
- Focus on **People & Blogs** or **Gaming** categories for higher chances of trending.
- Tailor content strategies to specific country preferences.
- Optimize content for **likes** and **engagement** to improve trendability.

---

📈 **Conclusion**  
Analyzing YouTube trending videos reveals varying audience preferences across different regions.  
While **music and entertainment** have universal appeal, creators must customize their strategies to align with local trends for maximum impact.  
**Success on YouTube requires a mix of global insight and localized targeting**, combined with continuous audience engagement.

---

📜 **License**  
This project is part of academic coursework and follows university assignment guidelines.

---

🚀 **Happy Analyzing!**

