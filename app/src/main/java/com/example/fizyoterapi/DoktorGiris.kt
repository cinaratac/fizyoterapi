package com.example.fizyoterapi

import android.content.Intent
import android.os.Bundle
import android.widget.Toast
import androidx.activity.enableEdgeToEdge
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat
import com.example.fizyoterapi.databinding.ActivityDoktorGirisBinding
import com.google.firebase.database.DataSnapshot
import com.google.firebase.database.DatabaseError
import com.google.firebase.database.FirebaseDatabase
import com.google.firebase.database.ValueEventListener

class DoktorGiris : AppCompatActivity() {
    lateinit var binding: ActivityDoktorGirisBinding
    override fun onCreate(savedInstanceState: Bundle?) {
        binding = ActivityDoktorGirisBinding.inflate(layoutInflater)
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContentView(binding.root)
        ViewCompat.setOnApplyWindowInsetsListener(findViewById(R.id.main)) { v, insets ->
            val systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars())
            v.setPadding(systemBars.left, systemBars.top, systemBars.right, systemBars.bottom)
            insets
        }

     val db = DataBaseHelper(this)



    binding.kaydol.setOnClickListener {
    val intent = Intent(this, DoktorKaydol::class.java)
    startActivity(intent)
    }
    binding.giris.setOnClickListener {
   val phone = binding.number.text.toString()
    if (phone.isEmpty()) {
        return@setOnClickListener
    }
    val password = binding.paswword.text.toString()
    if (password.isEmpty()) {
        return@setOnClickListener
    }
    if (db.checkDoktor(phone, password)) {

        val intent = Intent(this, Doktornavigasyon::class.java)
        startActivity(intent)


    }
    else {
        Toast.makeText(this, "TELEFON VEYA ŞİFRE HATALI", Toast.LENGTH_LONG).show()
    }

        val ref = FirebaseDatabase.getInstance().getReference("doktorlar")
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
                    Toast.makeText(this@DoktorGiris,"Firebase Hata: ${error.message}",Toast.LENGTH_SHORT).show()
                }
            })


    }




    }
}