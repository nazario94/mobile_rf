//package com.example.mobile
//
//import android.content.Context
//import android.telephony.CellInfo
//import android.telephony.TelephonyManager
//import io.flutter.embedding.android.FlutterActivity
//import io.flutter.embedding.engine.FlutterEngine
//import io.flutter.plugin.common.MethodChannel
//
//class MainActivity: FlutterActivity(){
//    private val CHANNEL = "cell_info"
//
//    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
//        super.configureFlutterEngine(flutterEngine)
//        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
//                call, result ->
//            if (call.method == "getCellInfo") {
//                val telephonyManager = getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager
//                val cellInfoList: List<CellInfo> = telephonyManager.allCellInfo
//                // Process cellInfoList to extract info and return
//                // For simplicity, just returning a placeholder
//                result.success(null) // Replace this with your actual data
//            } else {
//                result.notImplemented()
//            }
//        }
//    }
//}
