package com.example.fizyoterapi

import android.content.Intent
import android.os.Bundle
import android.widget.Toast
import androidx.activity.enableEdgeToEdge
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat
import com.example.fizyoterapi.databinding.ActivityMainBinding
import com.google.firebase.database.DataSnapshot
import com.google.firebase.database.DatabaseError
import com.google.firebase.database.FirebaseDatabase
import com.google.firebase.database.ValueEventListener

class MainActivity : AppCompatActivity() {
    val db = DataBaseHelper(this)


    private lateinit var binding: ActivityMainBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)

        enableEdgeToEdge()
        ViewCompat.setOnApplyWindowInsetsListener(findViewById(R.id.main)) { v, insets ->
            val systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars())
            v.setPadding(systemBars.left, systemBars.top, systemBars.right, systemBars.bottom)
            insets
        }



        binding.kaydol.setOnClickListener {
            val intent = Intent(this, kaydol::class.java)
            startActivity(intent)
        }

        binding.giris.setOnClickListener {
            val phone = binding.editTextPhone.text.toString()
            val password = binding.editTextTextPassword.text.toString()
            if (phone.isEmpty() && password.isEmpty()) {
                Toast.makeText(this, "Lütfen tüm alanları doldurun", Toast.LENGTH_SHORT).show()
            } else {
                if (db.checkHasta(phone, password)) {
                    val intent = Intent(this, Navigation::class.java)
                    startActivity(intent)
                } else {
                    Toast.makeText(this, "Telefon veya şifre hatalı", Toast.LENGTH_SHORT).show()
                }
            }
            val ref = FirebaseDatabase.getInstance().getReference("hastalar")
            ref.orderByChild("phone").equalTo(phone)
                .addListenerForSingleValueEvent(object: ValueEventListener {
                    override fun onDataChange(snapshot: DataSnapshot) {
                        if(snapshot.exists()){
                            var success = false
                            for(userSnap in snapshot.children){
                                val dbPassword = userSnap.child("password").getValue(String::class.java)
                                if(dbPassword == password){
                                    success = true
                                }
                            }
                            if(success){
                                //Toast.makeText(this@MainActivity,"Giriş Başarılı (Firebase)",Toast.LENGTH_SHORT).show()
                            } else {
                                //Toast.makeText(this@MainActivity,"Şifre Hatalı",Toast.LENGTH_SHORT).show()
                            }
                        } else {
                            //Toast.makeText(this@MainActivity,"Kullanıcı Bulunamadı",Toast.LENGTH_SHORT).show()
                        }
                    }

                    override fun onCancelled(error: DatabaseError) {
                        Toast.makeText(this@MainActivity,"Firebase Hata: ${error.message}",Toast.LENGTH_SHORT).show()
                    }
                })
        }

        binding.doktor.setOnClickListener {
            val intent = Intent(this, DoktorGiris::class.java)
            startActivity(intent)
        }


    }

}