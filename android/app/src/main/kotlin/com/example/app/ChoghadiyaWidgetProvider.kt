package com.example.app

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider
import org.json.JSONArray
import java.time.LocalDateTime
import java.time.format.DateTimeFormatter

class ChoghadiyaWidgetProvider : HomeWidgetProvider() {

    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray, widgetData: SharedPreferences) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.widget_layout).apply {
                
                // 1. Setup Refresh Button Intent
                val intent = Intent(context, ChoghadiyaWidgetProvider::class.java).apply {
                    action = AppWidgetManager.ACTION_APPWIDGET_UPDATE
                    putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, intArrayOf(widgetId))
                }
                val pendingIntent = PendingIntent.getBroadcast(
                    context, 
                    widgetId, 
                    intent, 
                    PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                )
                setOnClickPendingIntent(R.id.widget_refresh_btn, pendingIntent)

                // 2. Setup Open App Intent
                val launchIntent = Intent(context, MainActivity::class.java).apply {
                    action = Intent.ACTION_MAIN
                    addCategory(Intent.CATEGORY_LAUNCHER)
                    flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
                }
                val launchPendingIntent = PendingIntent.getActivity(
                    context, 
                    widgetId, 
                    launchIntent, 
                    PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                )
                setOnClickPendingIntent(R.id.widget_root, launchPendingIntent)

                // 2. Try to calculate current data from Schedule
                var foundCurrent = false
                val scheduleJson = widgetData.getString("choghadiya_schedule", null)
                
                if (scheduleJson != null) {
                    try {
                        val schedule = JSONArray(scheduleJson)
                        val now = LocalDateTime.now()
                        
                        for (i in 0 until schedule.length()) {
                            val slot = schedule.getJSONObject(i)
                            val startStr = slot.optString("start")
                            val endStr = slot.optString("end")
                            
                            // Parse ISO strings (e.g. 2023-10-25T14:30:00.000)
                            // Flutter DateTime.toString() usually produces ISO 8601
                            // We use simplistic parsing or standard formatter
                            // Note: We assume local time match for simplicity 
                            
                            if (startStr.isNotEmpty() && endStr.isNotEmpty()) {
                                // Remove Z if present? Or just parse standard
                                // Basic cleanup for common formats if needed
                                val start = LocalDateTime.parse(startStr, DateTimeFormatter.ISO_DATE_TIME)
                                val end = LocalDateTime.parse(endStr, DateTimeFormatter.ISO_DATE_TIME)
                                
                                if (now.isAfter(start) && now.isBefore(end)) {
                                    val name = slot.optString("name", "--")
                                    
                                    // Formatting time to HH:mm
                                    val timeLabel = "${start.format(DateTimeFormatter.ofPattern("HH:mm"))} - ${end.format(DateTimeFormatter.ofPattern("HH:mm"))}"
                                    
                                    setTextViewText(R.id.widget_current_name, name)
                                    setTextViewText(R.id.widget_time, timeLabel)
                                    foundCurrent = true
                                    break
                                }
                            }
                        }
                    } catch (e: Exception) {
                        e.printStackTrace()
                    }
                }

                // 3. Fallback to statically saved data if calculation failed (or no schedule)
                if (!foundCurrent) {
                    val name = widgetData.getString("choghadiya_name", "--")
                    val time = widgetData.getString("choghadiya_time", "--")
                    setTextViewText(R.id.widget_current_name, name)
                    setTextViewText(R.id.widget_time, time)
                }
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
