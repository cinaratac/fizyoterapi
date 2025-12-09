package com.example.fizyoterapi

import android.os.Bundle
import androidx.activity.enableEdgeToEdge
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat
import com.example.fizyoterapi.databinding.ActivityHastahareketBinding
import com.google.firebase.database.FirebaseDatabase
import java.text.SimpleDateFormat
import java.util.*

class hastahareket : AppCompatActivity() {
    lateinit var binding : ActivityHastahareketBinding
    private var startTime: Long = 0
    private var totalTimeToday: Long = 0
    private var phone: String? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        binding = ActivityHastahareketBinding.inflate(layoutInflater)
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContentView(binding.root)

        ViewCompat.setOnApplyWindowInsetsListener(findViewById(R.id.main)) { v, insets ->
            val systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars())
            v.setPadding(systemBars.left, systemBars.top, systemBars.right, systemBars.bottom)
            insets
        }

        phone = intent.getStringExtra("phone")
    }

    override fun onResume() {
        super.onResume()
        startTime = System.currentTimeMillis()
    }

    override fun onPause() {
        super.onPause()
        val endTime = System.currentTimeMillis()
        val sessionDuration = endTime - startTime
        totalTimeToday += sessionDuration
        saveDailyUsage(totalTimeToday)
    }

    private fun saveDailyUsage(totalTime: Long) {
        val date = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault()).format(Date())
        val ref = FirebaseDatabase.getInstance().getReference("hasta_kullanim")
        val userId = phone ?: return
        val data = mapOf(
            "date" to date,
            "totalTime" to totalTime
        )
        ref.child(userId).child(date).setValue(data)
    }

}