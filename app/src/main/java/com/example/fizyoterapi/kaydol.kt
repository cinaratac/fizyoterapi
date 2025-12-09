package com.example.fizyoterapi

import android.content.Intent
import android.os.Bundle
import android.widget.Toast
import androidx.activity.enableEdgeToEdge
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat
import com.example.fizyoterapi.databinding.ActivityKaydolBinding
import com.google.firebase.database.FirebaseDatabase


class kaydol : AppCompatActivity() {
    lateinit var binding: ActivityKaydolBinding
    override fun onCreate(savedInstanceState: Bundle?) {
        binding = ActivityKaydolBinding.inflate(layoutInflater)
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContentView(binding.root)
        ViewCompat.setOnApplyWindowInsetsListener(findViewById(R.id.main)) { v, insets ->
            val systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars())
            v.setPadding(systemBars.left, systemBars.top, systemBars.right, systemBars.bottom)
            insets
        }

        val db = DataBaseHelper(this)

        binding.kaydet.setOnClickListener {
            val number = binding.editTextPhone2.text.toString()
            val password = binding.editTextTextPassword.text.toString()
            val hastavarmi = db.checkHasta(number,password)
          /*  if(number.length !=11){
                Toast.makeText(applicationContext,"Lütfen geçerli bir telefon numarası giriniz",Toast.LENGTH_SHORT).show()

            }

           else */ if(hastavarmi) {
                Toast.makeText(
                    applicationContext,
                    "bu telefon numarasına sahip zaten bir kullanıcı var ",
                    Toast.LENGTH_SHORT
                ).show()
            }
           else  if (number.isNotEmpty() && password.isNotEmpty()) {
                db.insertHasta(number, password)
                Toast.makeText(applicationContext, "Kayıt Başarılı", Toast.LENGTH_SHORT).show()
                val intent = Intent(this, MainActivity::class.java)
                startActivity(intent)
                val ref = FirebaseDatabase.getInstance().getReference("hastalar")
                val userId = ref.push().key
                val user = mapOf(
                    "phone" to number,
                    "password" to password
                )
                ref.child(userId!!).setValue(user)
            }
            else {
                Toast.makeText(applicationContext, "Lütfen tüm alanları doldurun", Toast.LENGTH_SHORT).show()
            }



    }
}}
