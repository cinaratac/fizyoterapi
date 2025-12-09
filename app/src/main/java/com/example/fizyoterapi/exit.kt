package com.example.fizyoterapi

import android.content.Intent
import android.os.Bundle
import androidx.activity.enableEdgeToEdge
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat
import com.example.fizyoterapi.databinding.ActivityExitBinding

class exit : AppCompatActivity() {
    lateinit var binding: ActivityExitBinding
    override fun onCreate(savedInstanceState: Bundle?) {
        binding = ActivityExitBinding.inflate(layoutInflater)
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContentView(binding.root)
        ViewCompat.setOnApplyWindowInsetsListener(findViewById(R.id.main)) { v, insets ->
            val systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars())
            v.setPadding(systemBars.left, systemBars.top, systemBars.right, systemBars.bottom)
            insets
        }

       /* binding.exit.setOnClickListener {
            val db = DataBaseHelper(this)
            db.logoutUser()

            startActivity(Intent(this, MainActivity::class.java))
            finish()

        } */
    }
}