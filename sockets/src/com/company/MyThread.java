package com.company;

public class MyThread extends Thread {
    public void run()
    {
        System.out.println("running...");
    }
    public static void main(String args[])
    {
        MyThread t1 = new MyThread();
            // It does not start a separate call stack
        t1.run();
    }
}
