package com.example.fizyoterapi

import android.content.Intent
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.recyclerview.widget.LinearLayoutManager
import com.example.fizyoterapi.databinding.FragmentRecyclerBinding

class RecyclerFragment : Fragment() {

    private lateinit var binding: FragmentRecyclerBinding
    private lateinit var dataList: ArrayList<RecyclerData>
    private lateinit var titleList: Array<String>
    private lateinit var imageList: Array<Int>

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        binding = FragmentRecyclerBinding.inflate(inflater, container, false)

        // Verileri tanımla
        imageList = arrayOf(
            R.drawable.ic_launcher_background,
            R.drawable.ic_launcher_background,
            R.drawable.ic_launcher_background,
            R.drawable.ic_launcher_background
        )

        titleList = arrayOf("title1", "title2", "title3", "title4")

        dataList = ArrayList()
        setData()

        // RecyclerView ayarları
        val recyclerView = binding.recyclerView
        recyclerView.layoutManager = LinearLayoutManager(requireContext())
        recyclerView.adapter = R_adapter(dataList)

        return binding.root
    }

    private fun setData() {
        for (i in imageList.indices) {
            val data = RecyclerData(imageList[i], titleList[i])
            dataList.add(data)
        }
    }
}