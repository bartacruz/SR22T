# =====
# Doors
# =====

Doors = {};

Doors.new = func {
   obj = { parents : [Doors],
           crew : aircraft.door.new("instrumentation/doors/crew", 2.0),
           passenger : aircraft.door.new("instrumentation/doors/passenger", 2.0),
           baggage : aircraft.door.new("instrumentation/doors/baggage", 2.0),
         };
   return obj;
};

Doors.crewexport = func {
   me.crew.toggle();
}

Doors.passengerexport = func {
   me.passenger.toggle();
}

Doors.baggageexport = func {
   me.baggage.toggle();
}


# ==============
# Initialization
# ==============

# objects must be here, otherwise local to init()
doorsystem = Doors.new();

