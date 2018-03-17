class Track {
   ArrayList<Cone> trackElements = new ArrayList<Cone>();  
  
   Track () {
     
   }
   
   void populateRandom() {
     int numCones = int(random(10,30));
     for(int i = 0; i < numCones; i++)
     {
       Cone newCone = new Cone(random(0, width), random(0, height)); 
       trackElements.add(newCone);
       
     }
   }
   
   void display() {
     for(int i = 0; i < trackElements.size(); i++){
       trackElements.get(i).display(); 
     }
     
   }
  
}