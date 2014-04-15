functor
import
   Comp at '../../lib/component.ozf'
   Milli at 'x-oz://boot/Time'
   System
export
   new: CompNew
define
   fun {CompNew Name}
      {Comp.new comp(name:Name type:doubleclick
		     inPorts(input(proc{$ In Out Comp}
				      IP = {In.get}
				   in
				      case {Label IP}
				      of 'ButtonPress' andthen IP.button == 1 then T in
					 T = {Milli.getReferenceTime}
					 {System.show Comp.state.last#T}
					 if Comp.state.last > 0 andthen T-Comp.state.last < 500 then {Out.output {Record.adjoin IP doubleclick}} end
					 Comp.state.last := T
				      else skip
				      end
				   end)
			    )
		     outPorts(output)
		     state(last:~1)
		    )
      }
   end
end