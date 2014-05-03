functor
import
   Comp at '../../../lib/component.ozf'
export
   new: CompNewGen
define
   fun {CompNewGen Name} 
      {Comp.new comp(
		   name:Name type:'components/editor/labelentry/create'
		   inPorts(
		      input(proc{$ In Out Comp} IP in
			       IP = {In.get}
			       {Out.output set(text:IP.1)}
			       {Out.output display}
			       {Out.textchange textChanged(IP.1)}
			    end)
		      )
		   outPorts(output textchange)
		   )
      }
   end
end