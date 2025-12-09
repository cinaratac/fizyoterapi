package com.example.fizyoterapi

import android.os.Bundle
import androidx.activity.enableEdgeToEdge
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat
import androidx.drawerlayout.widget.DrawerLayout
import androidx.recyclerview.widget.LinearLayoutManager
import com.example.fizyoterapi.databinding.ActivityRecyclerwiewBinding

class recyclerwiew : AppCompatActivity() {
    private lateinit var drawerLayout: DrawerLayout
    lateinit var binding: ActivityRecyclerwiewBinding

    lateinit var dataList: ArrayList<RecyclerData>
    lateinit var titlelist: Array<String>
    lateinit var imagelist: Array<Int>
    override fun onCreate(savedInstanceState: Bundle?) {
        binding = ActivityRecyclerwiewBinding.inflate(layoutInflater)
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContentView(binding.root)
        ViewCompat.setOnApplyWindowInsetsListener(findViewById(R.id.main)) { v, insets ->
            val systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars())
            v.setPadding(systemBars.left, systemBars.top, systemBars.right, systemBars.bottom)
            insets
        }


          imagelist = arrayOf(
            R.drawable.ic_launcher_background,
            R.drawable.ic_launcher_background,
            R.drawable.ic_launcher_background,
            R.drawable.ic_launcher_background,)

        titlelist = arrayOf("title1", "title2", "title3", "title4")

        dataList = ArrayList()
        setdata()
        val recyclerwiew = binding.recyclerView
        recyclerwiew.layoutManager = LinearLayoutManager(this)
        recyclerwiew.adapter = R_adapter(dataList)

    // navigation menu


    }
    fun setdata (){
        for (i in imagelist.indices){
            val data = RecyclerData(imagelist[i],titlelist[i])
            this.dataList.add(data)
        }


    }

}


