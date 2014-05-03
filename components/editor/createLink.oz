functor
import
   Comp at '../../lib/component.ozf'
   SubComp at '../../lib/subcomponent.ozf'
export
   new: CompNewGen
define
   Unique = {NewCell 0}
   fun {OutPortWrapper Out} 
      proc{$ send(N Msg Ack)}
	 {Out.N Msg}
	 Ack = ack
      end
   end
   fun {CompNewGen Name}
      {Comp.new comp(
		   name:Name type:'components/editor/createLink'
		   inPorts(
		      input(proc{$ In Out Comp} IP in
			       IP = {In.get}
			       case IP
			       of beginLink(entryPoint:BPoint x:X y:Y comp:OutComp name:Name) andthen {Not Comp.state.click} then L CompName in
				  CompName = {VirtualString.toAtom "link"#@Unique}
				  Unique := @Unique + 1
				  L = {SubComp.new CompName type "./components/editor/link.fbp"}
				  Comp.state.link := L
				  % Bind port and create it
				  {L bind(ui_out {OutPortWrapper Out} widget_out)}
				  {L bind(actions_out {OutPortWrapper Out} actions_out)}
				  {L bind('ERROR' {OutPortWrapper Out} 'ERROR')}
				  % Set the initial position
				  {L send(actions_in moveBegin(x:X y:Y) _)}
				  {L send(actions_in moveEnd(x:X y:Y) _)}
				  {L send(actions_in lower _)}
				  {L start}
				  {L send(ui_in startline(x:X y:Y outComp:OutComp outPortName:Name bPoint:BPoint subComp:L) _)}
				  Comp.state.click := true
			       [] endLink(entryPoint:EPoint x:X y:Y comp:InComp name:Name) andthen Comp.state.click then 
				  {Comp.state.link send(actions_in moveEndPos(x:X y:Y) _)}
				  % send info about the "real" port
				  {Comp.state.link send(actions_in inComp(comp:InComp name:Name ePoint:EPoint) _)}
				  Comp.state.link := nil
				  Comp.state.click := false
				  % TODO : ButtonRelease to discard the line
				  % Issue : there is an ButtonRelease when createLink event is launched...
                               % [] 'ButtonRelease'(button:3 x:_ y:_) andthen Comp.state.click == true then
			       % 	  {Comp.state.link send(actions_in delete _)}
			       % 	  Comp.state.link := nil
			       % 	  Comp.state.bPoint := nil
			       % 	  Comp.state.click := false
			       [] 'Motion'(state:_ x:X y:Y) andthen Comp.state.link \= nil andthen Comp.state.click then
				  {Comp.state.link send(actions_in moveEndPos(x:{Int.toFloat X} y:{Int.toFloat Y}) _)}
			       else
				  skip
			       end
			    end)
		      )
		   outPorts(widget_out actions_out)
		   state(link:nil click:false)
		   )
      }
   end
end