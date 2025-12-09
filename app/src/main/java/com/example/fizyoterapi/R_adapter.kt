package com.example.fizyoterapi

import android.content.Intent
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView

class R_adapter (private val dataList: List<RecyclerData>) :
    RecyclerView.Adapter<R_adapter.ViewHolder>(){
    override fun onCreateViewHolder(
        parent: ViewGroup,
        viewType: Int
    ): ViewHolder {
        val view = LayoutInflater.from(parent.context).inflate(R.layout.reccyclerwiew, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(
        holder: ViewHolder,
        position: Int
    ) {
        val data = dataList[position]
        holder.itemImage.setImageResource(data.image)
        holder.itemText.text = data.title
    }

    override fun getItemCount(): Int {
        return dataList.size
    }

    class ViewHolder (view: View) : RecyclerView.ViewHolder(view) {
        val itemImage : ImageView = view.findViewById(R.id.item_image)
        val itemText : TextView = view.findViewById(R.id.item_text)

        init {

            itemText.setOnClickListener {
                var intent = Intent(view.context, hastahareket::class.java)
                intent.putExtra("phone", itemText.text.toString())
                view.context.startActivity(intent)

                }
        }
    }


    }
