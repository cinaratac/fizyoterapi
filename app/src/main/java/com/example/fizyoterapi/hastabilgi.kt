package com.example.fizyoterapi

import android.os.Bundle
import android.widget.Toast
import androidx.activity.enableEdgeToEdge
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat
import com.example.fizyoterapi.databinding.ActivityHastabilgiBinding
import com.google.firebase.database.FirebaseDatabase
import com.google.firebase.database.DataSnapshot
import com.google.firebase.database.DatabaseError
import com.google.firebase.database.ValueEventListener
import java.text.SimpleDateFormat
import java.util.*

class hastabilgi : AppCompatActivity() {
    lateinit var binding : ActivityHastabilgiBinding
    private var phone: String? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        binding = ActivityHastabilgiBinding.inflate(layoutInflater)
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContentView(binding.root)

        ViewCompat.setOnApplyWindowInsetsListener(findViewById(R.id.main)) { v, insets ->
            val systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars())
            v.setPadding(systemBars.left, systemBars.top, systemBars.right, systemBars.bottom)
            insets
        }

        phone = intent.getStringExtra("phone")

        if (phone != null) {
            loadDailyUsage(phone!!)
        }
    }

    private fun loadDailyUsage(phone: String) {
        val ref = FirebaseDatabase.getInstance().getReference("hasta_kullanim").child(phone)
        ref.addValueEventListener(object: ValueEventListener {
            override fun onDataChange(snapshot: DataSnapshot) {
                val builder = StringBuilder()
                for(daySnap in snapshot.children){
                    val date = daySnap.child("date").getValue(String::class.java)
                    val totalTime = daySnap.child("totalTime").getValue(Long::class.java)
                    builder.append("$date : ${totalTime?.div(1000)} saniye\n")
                }
                binding.textViewBilgi.text = builder.toString()
            }

            override fun onCancelled(error: DatabaseError) {
                Toast.makeText(this@hastabilgi,"Firebase Hata: ${error.message}",Toast.LENGTH_SHORT).show()
            }

        })

    }
    private fun formatDuration(millis: Long): String {
        val seconds = millis / 1000 % 60
        val minutes = millis / (1000 * 60) % 60
        val hours = millis / (1000 * 60 * 60)
        return String.format("%02d saat %02d dakika %02d saniye", hours, minutes, seconds)
    }

}