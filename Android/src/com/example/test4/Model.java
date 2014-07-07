package com.example.test4;

import java.util.ArrayList;

public class Model {

	 public static ArrayList<Item> Items;

	    public static void LoadModel() {

	        Items = new ArrayList<Item>();
	        Items.add(new Item(1, "CMYE_Little_Town_NJ.jpg", "CMYE Little Town NJ"));
	        Items.add(new Item(2, "Fiore_Deli_of_Hoboken.jpg", "Fiore Deli of Hoboken"));
	        Items.add(new Item(3, "M_and_P_Biancamano.jpg", "M and P Biancamano"));
	        Items.add(new Item(4, "The_Cuban_Restaurant_and_Bar.jpg", "The Cuban Restaurant an Bar"));
	        Items.add(new Item(5, "Vitos_Delicatessen.jpg", "Vitos Delicatessen"));

	    }

	    public static Item GetbyId(int id){

	        for(Item item : Items) {
	            if (item.Id == id) {
	                return item;
	            }
	        }
	        return null;
	    }

}
