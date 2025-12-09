package com.example.fizyoterapi

import android.content.ContentValues
import android.content.Context
import android.database.Cursor
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteOpenHelper



private var Database="DATA_FİZYO"
private var TABLE_HASTA="HASTALAR"
private var TABLE_DOKTOR="DOKTORLAR"
var column_phone="phone"
var cloumn_password="password"

var cloumn_sure="ekran_süresi"

var cloumn_id="id"

class DataBaseHelper (context: Context): SQLiteOpenHelper(context,Database,null,1){
    override fun onCreate(db: SQLiteDatabase?) {
        val createtable = "CREATE TABLE $TABLE_HASTA($cloumn_id integer primary key autoincrement,$column_phone varchar(50) , $cloumn_sure varchar(50),$cloumn_password varchar(50))"
        db?.execSQL(createtable)
        val createtable2 = "CREATE TABLE $TABLE_DOKTOR($column_phone varchar(50) , $cloumn_password varchar(50))"
        db?.execSQL(createtable2)
    }

    override fun onUpgrade(
        db: SQLiteDatabase?,
        oldVersion: Int,
        newVersion: Int
    ) {
        TODO("Not yet implemented")
    }

   fun insertHasta(phone:String,password:String){
       val db = this.writableDatabase
       val cv = ContentValues()
       cv.put(column_phone,phone)
       cv.put(cloumn_password,password)
       db.insert(TABLE_HASTA,null,cv)

   }

  fun insertDoktor(phone:String,password:String){
       val db = this.writableDatabase
       val cv = ContentValues()
       cv.put(column_phone,phone)
       cv.put(cloumn_password,password)
       db.insert(TABLE_DOKTOR,null,cv)

   }


  fun checkHasta(phone:String,password:String):Boolean {
      val db = this.readableDatabase
      val query = "select * from $TABLE_HASTA where $column_phone='$phone' and $cloumn_password='$password'"
      val cursor = db.rawQuery(query, null)
      val exists = cursor.count > 0
      cursor.close()
      return exists
  }

    fun checkDoktor(phone:String,password:String):Boolean {
    val db = this.readableDatabase
    val query = "select * from $TABLE_DOKTOR where $column_phone='$phone' and $cloumn_password='$password'"
    val cursor = db.rawQuery(query, null)
    val exists = cursor.count > 0
    cursor.close()
    return exists

}
    fun getAllHastaPhones(): List<String> {
        val phoneList = mutableListOf<String>()
        val db = this.readableDatabase
        val cursor: Cursor = db.rawQuery("SELECT $column_phone FROM $TABLE_HASTA", null)

        if (cursor.moveToFirst()) {
            do {
                val phone = cursor.getString(cursor.getColumnIndexOrThrow(column_phone))
                phoneList.add(phone)
            } while (cursor.moveToNext())
        }

        cursor.close()
        db.close()
        return phoneList
    }





}