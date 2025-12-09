package com.example.fizyoterapi

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.recyclerview.widget.LinearLayoutManager
import com.example.fizyoterapi.databinding.FragmentRecyclerBinding

class HastaFragment : Fragment() {

    private var _binding: FragmentRecyclerBinding? = null
    private val binding get() = _binding!!

    private lateinit var titleList: ArrayList<String>
    private lateinit var dataList: ArrayList<HastaData>
    private lateinit var dataImage: Array<Int>

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        _binding = FragmentRecyclerBinding.inflate(inflater, container, false)

        val db = DataBaseHelper(requireContext())
        titleList = ArrayList(db.getAllHastaPhones())
        dataImage = Array(titleList.size) { R.drawable.ic_launcher_background }

        dataList = ArrayList()
        setData()

        binding.recyclerView.layoutManager = LinearLayoutManager(requireContext())
        binding.recyclerView.adapter = Hasta_adapter(dataList)

        return binding.root
    }

    private fun setData() {
        for (i in titleList.indices) {
            val data = HastaData(dataImage[i], titleList[i])
            dataList.add(data)
        }
    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }
}