package com.example.app

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider

class ChoghadiyaWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray, widgetData: SharedPreferences) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.widget_layout).apply {
                // Get data from SharedPreferences (set by Flutter)
                val name = widgetData.getString("choghadiya_name", "--")
                val time = widgetData.getString("choghadiya_time", "--")
                
                setTextViewText(R.id.widget_current_name, name)
                setTextViewText(R.id.widget_time, time)
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
