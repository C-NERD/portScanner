package com.scanner

import java.net.Socket
import java.net.InetSocketAddress
import java.net.SocketTimeoutException

fun main(args : Array<String>){
    val start = args[0].toInt()
    val end = args[1].toInt()
    val url = args[2]

    for(port in start..end){
        val socket = Socket()

        try{
            socket.connect(InetSocketAddress(url, port), 5 * 1000)
            println("port " + port.toString() + " is openned")
        }catch (exception: SocketTimeoutException){
            println("port " + port.toString() + " is closed")
        }finally{
            socket.close()
        }
    }
}