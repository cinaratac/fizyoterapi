package com.example.fizyoterapi

import android.content.Intent
import android.os.Bundle
import android.widget.Toast
import androidx.activity.enableEdgeToEdge
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat
import com.example.fizyoterapi.databinding.ActivityDoktorKaydolBinding
import com.google.firebase.database.FirebaseDatabase

class DoktorKaydol : AppCompatActivity() {
    lateinit var binding : ActivityDoktorKaydolBinding
    override fun onCreate(savedInstanceState: Bundle?) {
        binding = ActivityDoktorKaydolBinding.inflate(layoutInflater)
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContentView(binding.root)
        ViewCompat.setOnApplyWindowInsetsListener(findViewById(R.id.main)) { v, insets ->
            val systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars())
            v.setPadding(systemBars.left, systemBars.top, systemBars.right, systemBars.bottom)
            insets
        }


        val db = DataBaseHelper(this)

        binding.dKaydet.setOnClickListener {
            val phone = binding.kDPhone.text.toString()
            if (phone.isEmpty()) {
                return@setOnClickListener
            }
            val password = binding.kDPassword.text.toString()
            if (password.isEmpty()) {
                return@setOnClickListener
            }
            if (db.checkDoktor(phone, password)) {
                Toast.makeText(this, "Bu telefon numarasına sahip zaten bir doktor var", Toast.LENGTH_SHORT).show()

            }
            else
            db.insertDoktor(phone, password)
            val ref = FirebaseDatabase.getInstance().getReference("doktorlar")
            val userId = ref.push().key
            val user = mapOf(
                "phone" to phone,
                "password" to password
            )
            ref.child(userId!!).setValue(user)
        }

            val intent = Intent(this, DoktorGiris::class.java)
            startActivity(intent)
            finish()

        }



    }
