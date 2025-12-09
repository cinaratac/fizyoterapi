package com.example.fizyoterapi

import android.content.Intent
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.EditText
import android.widget.ImageView
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView

class Hasta_adapter(private val dataList: List<HastaData>) : RecyclerView.Adapter<Hasta_adapter.ViewHolder>(){
    override fun onCreateViewHolder(
        parent: ViewGroup,
        viewType: Int
    ): ViewHolder {
        val view = LayoutInflater.from(parent.context).inflate(R.layout.hastarecycler, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(
        holder: ViewHolder,
        position: Int
    ) {
        val data = dataList[position]
        holder.itemImage.setImageResource(data.image)
        holder.itemEditText.setText(data.title)
    }

    override fun getItemCount(): Int {
        return dataList.size

    }

    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        val itemImage: ImageView = view.findViewById(R.id.itemImageHasta)
        val itemEditText: TextView = view.findViewById(R.id.itemEditTextHasta)
        init {
            itemEditText.setOnClickListener {
                val intent = Intent(view.context, hastabilgi::class.java)
                intent.putExtra("phone", itemEditText.text.toString())
                view.context.startActivity(intent)
            }
        }

}


}